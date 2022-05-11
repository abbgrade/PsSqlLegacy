task InstallBuildDependencies -Jobs {
    Install-Module platyPs -ErrorAction Stop
}

task InstallTestDependencies -Jobs {
}, Testdata.Create

task InstallReleaseDependencies -Jobs {
}
