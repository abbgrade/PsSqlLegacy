function Initialize-SqlPackage {

    <#

    .SYNOPSIS
    Configures SqlCmd

    .DESCRIPTION
    Invoke-SqlCmd requires a path of the SQLCMD binary, that depend on your current installation.

    #>

    [CmdletBinding()]
    param(
        # Path to the SQLPACKAGE binary.
        [Parameter( Mandatory )]
        [ValidateScript({ $_.Exists })]
        [System.IO.FileInfo] $Path
    )

    $Global:SqlPackage = $Path
}
