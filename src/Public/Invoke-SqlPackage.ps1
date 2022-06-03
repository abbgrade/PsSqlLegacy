function Invoke-SqlPackage {
    <#

    .SYNOPSIS
    Executes SQLCMD

    .DESCRIPTION
    Wrapper tp the commandline tool SQLPACKAGE.
    It provides parameter validation, output and error handling.

    .NOTES
    Check https://github.com/abbgrade/PsDac and https://github.com/abbgrade/PsSmo if one of them already supports your use case. They provide better PowerShell integration.

    .LINK
    https://docs.microsoft.com/de-de/sql/tools/sqlpackage?view=sql-server-ver15

    #>

    [CmdletBinding()]
    param(
        # Flag if a install script should be created.
        [Parameter( Mandatory, ParameterSetName = 'Script' )]
        [string] $Script,

        # Flag if a database should be published.
        [Parameter( Mandatory, ParameterSetName = 'Publish' )]
        [switch] $Publish,

        [Parameter( Mandatory, ParameterSetName = 'Extract' )]
        [switch] $Extract,

        # Path to the dacpac file.
        [Parameter( Mandatory, ParameterSetName = 'Publish' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'Extract' )]
        # [ValidateScript({ $_.Exists })]
        [System.IO.FileInfo] $DacPac,

        # Name of the SQL Server Instance to publish the dacpac to.
        [Parameter( Mandatory, ParameterSetName = 'Publish', ValueFromPipelineByPropertyName )]
        [Alias('ServerInstance', 'DataSource')]
        [ValidateNotNullOrEmpty()]
        [string] $TargetServerName,

        # Username for the login.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName )]
        [Alias('Username')]
        [string] $TargetUser,

        # Password for the login.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName )]
        [Alias('Password')]
        [string] $TargetPassword,

        # Name of the SQL database to publish the dacpac to.
        [Parameter( Mandatory, ParameterSetName = 'Publish', ValueFromPipelineByPropertyName )]
        [Alias('DatabaseName', 'Database')]
        [ValidateNotNullOrEmpty()]
        [string] $TargetDatabaseName,

        # Name of the SQL Server Instance to publish the dacpac to.
        [Parameter( Mandatory, ParameterSetName = 'Extract', ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [string] $SourceServerName,

        # Username for the login.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName )]
        [string] $SourceUser,

        # Password for the login.
        [Parameter( Mandatory = $false, ValueFromPipelineByPropertyName )]
        [string] $SourcePassword,

        # AccessToken for the login
        [Parameter( ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [string] $AccessToken,

        # Name of the SQL database to publish the dacpac to.
        [Parameter( Mandatory, ParameterSetName = 'Extract', ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [string] $SourceDatabaseName,

        # Flag if the SQL Server is a Azure SQL Server.
        [Parameter( ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [switch] $AzureSql,

        # Flag if interactive authentication is used.
        [Parameter( ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [switch] $InteractiveAuthentication,

        # Flag if surplus contraints should be dropped.
        [ValidateNotNullOrEmpty()]
        [bool] $DropConstraintsNotInSource = $false,

        # Flag if surplus triggers should be dropped.
        [ValidateNotNullOrEmpty()]
        [bool] $DropDmlTriggersNotInSource = $false,

        # Flag if surplus properties should be dropped.
        [ValidateNotNullOrEmpty()]
        [bool] $DropExtendedPropertiesNotInSource = $false,

        # Flag if surplus indices should be dropped.
        [ValidateNotNullOrEmpty()]
        [bool] $DropIndexesNotInSource = $false,

        # Flag if surplus objects should be dropped.
        [ValidateNotNullOrEmpty()]
        [bool] $DropObjectsNotInSource = $false,

        # Flag if surplus permissions should be dropped.
        [ValidateNotNullOrEmpty()]
        [bool] $DropPermissionsNotInSource = $false,

        # Flag if surplus role members should be dropped.
        [ValidateNotNullOrEmpty()]
        [bool] $DropRoleMembersNotInSource = $false,

        # Flag if surplus statistics should be dropped.
        [ValidateNotNullOrEmpty()]
        [bool] $DropStatisticsNotInSource = $false,

        # Timeout is seconds for the execution.
        [ValidateNotNullOrEmpty()]
        [int] $Timeout,

        # Values for the variables used in the dacpac.
        [ValidateNotNull()]
        [hashtable] $Variables = @{},

        # Force the action and accept the risk of data loss.
        [Parameter( ParameterSetName = 'Publish' )]
        [switch] $Force
    )

    # soon...
    # Write-Warning 'This cmdlet is deprecated use PsDac instead'

    if ( -not $Global:SqlPackage ) {
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
                if ( $AccessToken ) {
                    $arguments += "/AccessToken:$AccessToken"
                    $arguments += "/TargetDatabaseName:""$TargetDatabaseName"""
                    $arguments += "/TargetServerName:""$TargetServerName"""
                } else {
                    $Authentication = 'Active Directory Integrated'
                    if ( $InteractiveAuthentication ) {
                        $Authentication = 'Active Directory Interactive'
                    }
                    $arguments += "/TargetConnectionString:""Server='$TargetServerName';Authentication=$Authentication;Database='$TargetDatabaseName';"""
                }
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

            if ( $Force.IsPresent ) {
                $arguments += '/p:BlockOnPossibleDataLoss=False'
            }
        }
        Extract {

            $arguments += '/Action:Extract'

            $arguments += "/TargetFile:""$DacPac"""

            $arguments += "/SourceDatabaseName:""$SourceDatabaseName"""
            $arguments += "/SourceServerName:""$SourceServerName"""

            if ( $SourceUser ) {
                $arguments += "/SourceUser:""$SourceUser"""
                $arguments += "/SourcePassword:""$SourcePassword"""
            }

            if ( $Timeout -ne $null ) {
                $arguments += "/SourceTimeout:$Timeout"
            }
        }
        default {
            throw "ParameterSet $( $PSCmdlet.ParameterSetName ) not implemented."
        }
    }

    foreach ( $variable in $Variables.GetEnumerator() ) {
        $arguments += "/Variables:$( $variable.Key )=""$( $variable.Value )"""
    }

    #region Prepare process

    $process = New-Object System.Diagnostics.Process

    $process.StartInfo.FileName = $Global:SqlPackage
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
        }
        elseif ( $process.WaitForExit( $timeoutMS ) ) {
            $returnCode = $process.ExitCode
        }
        elseif ( $process.HasExited ) {
            $returnCode = $process.ExitCode
        }
        else {
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

    if ( $returnCode -ne 0 ) {
        throw "SqlPackage exit code $returnCode; err: '$standardError'."
    }

    #endregion
}
