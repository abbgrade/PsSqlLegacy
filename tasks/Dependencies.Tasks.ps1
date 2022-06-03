task InstallBuildDependencies -Jobs {
    Install-Module platyPs -ErrorAction Stop
}

task InstallTestDependencies -Jobs {
}

task InstallReleaseDependencies -Jobs {
}
