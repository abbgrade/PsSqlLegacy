function Initialize-SqlCmd {

    [CmdletBinding()]
    param(
        [Parameter( Mandatory )]
        [ValidateScript({ $_.Exists })]
        [System.IO.FileInfo] $Path
    )

    $Module:SqlCmd = $Path
}