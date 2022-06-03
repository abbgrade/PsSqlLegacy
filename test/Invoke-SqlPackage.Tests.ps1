#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Invoke-SqlPackage {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLegacy.psd1 -Force
        Initialize-LegacySqlPackage -Path 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\SqlPackage.exe'

        $ServerInstance = '(localdb)\MSSQLLocalDB'
        $DatabaseName = 'AzureStorageEmulatorDb510'
    }

    it 'Extract' {
        Invoke-LegacySqlPackage -Extract `
            -SourceServerName $ServerInstance `
            -SourceDatabaseName $DatabaseName `
            -DacPac ./test.dacpac `
            -ErrorAction Stop
    }

    it 'Publish' {
        Invoke-LegacySqlPackage -Publish `
            -TargetServerName $ServerInstance `
            -TargetDatabaseName "$DatabaseName-neu" `
            -DacPac ./test.dacpac `
            -ErrorAction Stop
    }
}
