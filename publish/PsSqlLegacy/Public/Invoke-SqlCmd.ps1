function Invoke-SqlCmd
{
    <#

    .LINK
    https://docs.microsoft.com/de-de/sql/tools/sqlcmd-utility?view=sql-server-ver15

    #>

    [CmdletBinding()]
    param(
        [Parameter( Mandatory, ParameterSetName='File' )]
        [ValidateScript({ $_.Exists })]
        [Alias('File')]
        [System.IO.FileInfo] $InputFile,

        [Parameter( Mandatory, ParameterSetName='Command' )]
        [ValidateNotNullOrEmpty()]
        [string] $Command,

        [Parameter( Mandatory, ValueFromPipelineByPropertyName )]
        [Alias('DataSource')]
        [ValidateNotNullOrEmpty()]
        [string] $ServerInstance,

        [Parameter( ValueFromPipelineByPropertyName )]
        [PSCredential] $DatabaseCredential,

        [Parameter( ValueFromPipelineByPropertyName )]
        [PSCredential] $WindowsCredential,

        [Parameter( ValueFromPipelineByPropertyName )]
        [string] $AccessToken,

        [Parameter( ValueFromPipelineByPropertyName )]
        [ValidateNotNullOrEmpty()]
        [Alias('Database')]
        [string] $DatabaseName,

        [ValidateRange(-1, 30)]
        [int] $ErrorLevel = 0,

        [ValidateRange(-1, 30)]
        [int] $ErrorSeverityLevel = 10,

        [ValidateNotNullOrEmpty()]
        [switch] $TerminateOnError,

        [Parameter( ValueFromPipelineByPropertyName )]
        [Alias('ConnectionTimeout')]
        [int] $Timeout,

        [hashtable] $Variables
    )

    # soon...
    #Write-Warning 'This cmdlet is deprecated use PsSqlClient or PsSmo instead'

    if ( -not $Module:SqlCmd ) {
        throw "SqlCmd is not inizialized. Please run Initialize-SqlCmd."
    }

    $arguments = @()

    [string] $script = $null
    switch ($PSCmdlet.ParameterSetName) {
        File {
            $arguments += "-i ""$InputFile"""
            $script = $InputFile
        }
        Command {
            $arguments += "-Q ""$Command"""
            $script = $Command
        }
    }

    if ( $DatabaseName ) {
        $arguments += "-d ""$DatabaseName"""
    }

    $Credential = $null
    if ( $DatabaseCredential ) {
        $Credential = $DatabaseCredential
    }
    if ( $WindowsCredential ) {
        $Credential = $WindowsCredential
    }

    if ( $Credential ) {
        Write-Verbose "use credential-based authentication."
        $arguments += "-U $( $Credential.UserName )"

        if ( $Credential.GetNetworkCredential().Password ) {
            $arguments += "-P $( $Credential.GetNetworkCredential().Password )"
        }
    }

    if ( $AccessToken ) {
        Write-Verbose "use token-based authentication."
        $arguments += "-P $AccessToken"
    }

    if ( $ServerInstance ) {
        $arguments += "-S ""$ServerInstance"""

        if ( $ServerInstance.Contains( 'database.windows.net' ) -and -not $DatabaseCredential ) {
            Write-Verbose "use azure active directory."
            $arguments += "-G" # use Azure Active Directory authentication
        }
    }

    if ( $Timeout ) {
        $arguments += "-t $Timeout"
    }

    $arguments += "-X"
    $arguments += "-m$ErrorLevel"
    $arguments += "-V $ErrorSeverityLevel"
    if ( $TerminateOnError ) {
        $arguments += "-b"
    }
    foreach ( $variable in $Variables.Keys ) {
        $arguments += "-v $variable=""$( $Variables[$variable] )"""
    }

    #region Prepare process

    $process = New-Object System.Diagnostics.Process

    $process.StartInfo.FileName = $Module:SqlCmd
    $process.StartInfo.RedirectStandardError = $true
    $process.StartInfo.RedirectStandardOutput = $true
    $process.StartInfo.UseShellExecute = $false
    $process.StartInfo.CreateNoWindow = $true
    $process.StartInfo.Arguments = $arguments

    #endregion

    if ( $process.StartInfo.Arguments -notlike '*-P *' ) {
        Write-Verbose "$( $process.StartInfo.FileName ) $( $process.StartInfo.Arguments )"
    }

    #region Start process

    $outputBuffer = New-Object System.Text.StringBuilder
    $errorBuffer = New-Object System.Text.StringBuilder

    $oScripBlock = {
        if (! [String]::IsNullOrEmpty($EventArgs.Data)) {
            $Event.MessageData.AppendLine($EventArgs.Data)
            Write-Verbose $EventArgs.Data
        }
    }

    $eScripBlock = {
        if (! [String]::IsNullOrEmpty($EventArgs.Data)) {
            $Event.MessageData.AppendLine($EventArgs.Data)
            Write-Warning $EventArgs.Data
        }
    }

    try {

        $outputEvent = Register-ObjectEvent -InputObject $process `
            -Action $oScripBlock -EventName 'OutputDataReceived' `
            -MessageData $outputBuffer

        $errorEvent = Register-ObjectEvent -InputObject $process `
            -Action $eScripBlock -EventName 'ErrorDataReceived' `
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
            Write-Verbose "Invoke-SqlCmd: Timeout $Timeout reached."
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

    if ( $standardOutput -contains 'Timeout expired' ) {
        Write-Verbose "Invoke-SqlCmd: Timeout $Timeout reached."
        $returnCode = -1
    }

    if ( $returnCode -ne 0 )
    {
        Write-Verbose "Invoke-SqlCmd: '$script' Output $( $standardOutput.Length ),  Error $( $standardError.Length ) chars"
        # Write-Verbose $standardOutput
        throw "SqlCmd exit code $returnCode; out: '$standardOutput'; err: '$standardError'."
    }

    #endregion
}
