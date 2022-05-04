function Invoke-SqlPackage
{
    <#

    .LINK
    https://docs.microsoft.com/de-de/sql/tools/sqlpackage?view=sql-server-ver15
    
    #>

    [CmdletBinding()]
    param(
        [Parameter( Mandatory, ParameterSetName='Script' )]
        [string] $Script,

        [Parameter( Mandatory, ParameterSetName='Publish' )]
        [switch] $Publish,

        [Parameter( Mandatory )]
        [ValidateScript({ $_.Exists })]
        [System.IO.FileInfo] $DacPac,

        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [Alias('ServerInstance', 'DataSource')]
        [ValidateNotNullOrEmpty()]
        [string] $TargetServerName,

        [Parameter( Mandatory=$false, ValueFromPipelineByPropertyName )]
        [Alias('Username')]
        [string] $TargetUser,

        [Parameter( Mandatory=$false, ValueFromPipelineByPropertyName )]
        [Alias('Password')]
        [string] $TargetPassword,

        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [Alias('DatabaseName', 'Database')]
        [ValidateNotNullOrEmpty()]
        [string] $TargetDatabaseName,

        [Parameter( ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [switch] $AzureSql,

        [ValidateNotNullOrEmpty()]
        [bool] $DropConstraintsNotInSource = $false,

        [ValidateNotNullOrEmpty()]
        [bool] $DropDmlTriggersNotInSource = $false,

        [ValidateNotNullOrEmpty()]
        [bool] $DropExtendedPropertiesNotInSource = $false,

        [ValidateNotNullOrEmpty()]
        [bool] $DropIndexesNotInSource = $false,

        [ValidateNotNullOrEmpty()]
        [bool] $DropObjectsNotInSource = $false,

        [ValidateNotNullOrEmpty()]
        [bool] $DropPermissionsNotInSource = $false,

        [ValidateNotNullOrEmpty()]
        [bool] $DropRoleMembersNotInSource = $false,

        [ValidateNotNullOrEmpty()]
        [bool] $DropStatisticsNotInSource = $false,

        [ValidateNotNullOrEmpty()]
        [int] $Timeout,

        [ValidateNotNull()]
        [hashtable] $Variables = @{}
    )

    if ( -not $Module:SqlPackage ) {
        throw "SqlPackage is not inizialized. Please run Initialize-SqlPackage."
    }

    if ( $TargetServerName.Contains('.database.windows.net') -and -not $AzureSql ) {
        Write-Verbose 'Overwrite AzureSql flag to enabled.'
        $AzureSql = $true
    }

    $arguments = @()

    switch ( $PSCmdlet.ParameterSetName ) {
        Publish {
            $arguments += '/Action:Publish'
            $arguments += "/SourceFile:""$DacPac"""

            if ( $AzureSql ) {
                $arguments += "/TargetConnectionString:""Server='$TargetServerName';Authentication=Active Directory Integrated;Database='$TargetDatabaseName';"""
            }
            else {

                $arguments += "/TargetDatabaseName:""$TargetDatabaseName"""
                $arguments += "/TargetServerName:""$TargetServerName"""

                if ( $TargetUser ) {
                    $arguments += "/TargetUser:""$TargetUser"""
                    $arguments += "/TargetPassword:""$TargetPassword"""
                }

                if ( $Timeout -ne $null ) {
                    $arguments += "/TargetTimeout:$Timeout"
                }
            }

            $arguments += "/p:DropConstraintsNotInSource=""$DropConstraintsNotInSource"""
            $arguments += "/p:DropDmlTriggersNotInSource=""$DropDmlTriggersNotInSource"""
            $arguments += "/p:DropExtendedPropertiesNotInSource=""$DropExtendedPropertiesNotInSource"""
            $arguments += "/p:DropIndexesNotInSource=""$DropIndexesNotInSource"""
            $arguments += "/p:DropObjectsNotInSource=""$DropObjectsNotInSource"""
            $arguments += "/p:DropPermissionsNotInSource=""$DropPermissionsNotInSource"""
            $arguments += "/p:DropRoleMembersNotInSource=""$DropRoleMembersNotInSource"""
            $arguments += "/p:DropStatisticsNotInSource=""$DropStatisticsNotInSource"""
        }
        default {
            throw "ParameterSet $( $PSCmdlet.ParameterSetName ) not implemented."
        }
    }

    foreach( $variable in $Variables.GetEnumerator() ) {
        $arguments += "/Variables:$( $variable.Key )=""$( $variable.Value )"""
    }

    #region Prepare process
    
    $process = New-Object System.Diagnostics.Process

    $process.StartInfo.FileName = $Module:SqlPackage
    $process.StartInfo.RedirectStandardError = $true
    $process.StartInfo.RedirectStandardOutput = $true
    $process.StartInfo.UseShellExecute = $false
    $process.StartInfo.CreateNoWindow = $true
    $process.StartInfo.Arguments = $arguments

    #endregion

    Write-Verbose "$( $process.StartInfo.FileName ) $( $process.StartInfo.Arguments )"
    
    #region Start process

    $outputBuffer = New-Object System.Text.StringBuilder
    $errorBuffer = New-Object System.Text.StringBuilder

    $sScripBlock = {
        if (! [String]::IsNullOrEmpty($EventArgs.Data)) {
            $Event.MessageData.AppendLine($EventArgs.Data)
        }
    }

    try {

        $outputEvent = Register-ObjectEvent -InputObject $process `
            -Action $sScripBlock -EventName 'OutputDataReceived' `
            -MessageData $outputBuffer

        $errorEvent = Register-ObjectEvent -InputObject $process `
            -Action $sScripBlock -EventName 'ErrorDataReceived' `
            -MessageData $errorBuffer

        $process.Start() | Out-Null
        $process.BeginOutputReadLine();
        $process.BeginErrorReadLine();

        $timeoutMS = ($Timeout + 5 ) * 1000
        if ( -not $Timeout ) {
            $process.WaitForExit()
            $returnCode = $process.ExitCode
        } elseif ( $process.WaitForExit( $timeoutMS ) )
        {
            $returnCode = $process.ExitCode
        } elseif ( $process.HasExited )
        {
            $returnCode = $process.ExitCode
        }
        else
        {
            Write-Verbose "Invoke-SqlPackage: Timeout $Timeout reached."
            $process.Kill()
            $returnCode = -1
        }
    }
    finally {
        Unregister-Event -SourceIdentifier $outputEvent.Name
        Unregister-Event -SourceIdentifier $errorEvent.Name
    }

    #endregion
    #region handle result

    $standardOutput = $outputBuffer.ToString().Trim()
    $standardError = $errorBuffer.ToString().Trim()

    $process.Close() | Out-Null

    Write-Verbose "Invoke-SqlPackage: '$scriptName' Output $( $standardOutput.Length ) chars: $standardOutput"
    Write-Verbose "Invoke-SqlPackage: '$scriptName' Error $( $standardError.Length ) chars: $standardError"

    if ( $standardError.EndsWith('Timeout expired') ) {
        Write-Verbose "Invoke-SqlPackage: Timeout $Timeout reached."
        $returnCode = -1
    }

    if ( $returnCode -ne 0 )
    {
        throw "SqlPackage exit code $returnCode; err: '$standardError'."
    }

    #endregion
}
