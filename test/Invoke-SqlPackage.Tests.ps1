#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Invoke-SqlPackage {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLegacy.psd1 -Force
        Initialize-LegacySqlPackage -Path 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\SqlPackage.exe'
    }

    It Exists {
        Get-Command -Name Invoke-LegacySqlCmd -Module PsSqlLegacy | Should -Not -BeNullOrEmpty
    }

    Context Database {

        BeforeAll {
            $ServerInstance = '(localdb)\MSSQLLocalDB'
            $DatabaseName = 'AzureStorageEmulatorDb510'
        }

        It Extracts {
            Invoke-LegacySqlPackage -Extract `
                -SourceServerName $ServerInstance `
                -SourceDatabaseName $DatabaseName `
                -DacPac ./test.dacpac `
                -ErrorAction Stop
        }

        It Publish {
            Invoke-LegacySqlPackage -Publish `
                -TargetServerName $ServerInstance `
                -TargetDatabaseName "$DatabaseName-neu" `
                -DacPac ./test.dacpac `
                -ErrorAction Stop
        }
    }
}
