function Initialize-SqlPackage {

    [CmdletBinding()]
    param(
        [Parameter( Mandatory )]
        [ValidateScript({ $_.Exists })]
        [System.IO.FileInfo] $Path
    )

    $Module:SqlPackage = $Path
}