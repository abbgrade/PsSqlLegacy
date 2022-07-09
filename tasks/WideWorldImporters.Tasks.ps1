#Requires -Modules 'Invoke-MsBuild'

[System.IO.DirectoryInfo] $SqlServerSamplesDirectory = "$PSScriptRoot\..\test\sql-server-samples"
[string] $WwiSsdtRelativePath = 'samples/databases/wide-world-importers/wwi-ssdt/wwi-ssdt'
[System.IO.DirectoryInfo] $WwiSsdtDirectory = Join-Path $SqlServerSamplesDirectory $WwiSsdtRelativePath
[System.IO.FileInfo] $WideWorldImportersProject = Join-Path $SqlServerSamplesDirectory $WwiSsdtRelativePath "WideWorldImporters.sqlproj"
[System.IO.FileInfo] $WideWorldImportersDacPac = Join-Path $SqlServerSamplesDirectory $WwiSsdtRelativePath "bin\Debug\WideWorldImporters.dacpac"

task WideWorldImporters.DacPac.Clean -If { $SqlServerSamplesDirectory.Exists } -Jobs {
    Remove-Item $SqlServerSamplesDirectory -Recurse -Force
}

task WideWorldImporters.DacPac.AddSolution -If { -Not $SqlServerSamplesDirectory.Exists } -Jobs {
    New-Item $SqlServerSamplesDirectory -ItemType Directory -ErrorAction Continue
}

task WideWorldImporters.DacPac.InitSolution -If { -Not ( Test-Path "$SqlServerSamplesDirectory\.git" ) } -Jobs WideWorldImporters.DacPac.AddSolution, {
    Push-Location $SqlServerSamplesDirectory
    exec { git init }
    exec { git remote add origin -f https://github.com/microsoft/sql-server-samples.git }
    Pop-Location
}

task WideWorldImporters.DacPac.CheckoutSolution -If { -Not $WwiSsdtDirectory.Exists } -Jobs WideWorldImporters.DacPac.InitSolution, {
    Push-Location $SqlServerSamplesDirectory
    exec { git config core.sparseCheckout true }
    Set-Content .git/info/sparse-checkout $WwiSsdtRelativePath
    exec { git checkout master }
    Pop-Location
}

task WideWorldImporters.DacPac.Create -If { -Not $WideWorldImportersDacPac.Exists -And -Not $IsLinux } -Jobs WideWorldImporters.DacPac.CheckoutSolution, {
    # # can be enabled if dotnet core build is public and working
    # exec { dotnet build "$SqlServerSamplesDirectory\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\WideWorldImporters.sqlproj" /p:NetCoreBuild=true }

    assert $WideWorldImportersProject
    Write-Verbose "WideWorldImportersProject: $WideWorldImportersProject"

    Invoke-MsBuild $WideWorldImportersProject

    assert ( Test-Path $WideWorldImportersDacPac )
}
