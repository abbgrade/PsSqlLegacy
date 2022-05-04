function Initialize-SqlCmd {

    [CmdletBinding()]
    param(
        [Parameter( Mandatory )]
        [ValidateScript({ $_.Exists })]
        [System.IO.FileInfo] $Path
    )

    $Global:SqlCmd = $Path
}
