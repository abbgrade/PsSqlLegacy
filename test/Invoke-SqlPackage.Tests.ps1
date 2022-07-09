#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.2.0' }, @{ ModuleName='PsSqlTestServer'; ModuleVersion='1.2.0' }

Describe Invoke-SqlPackage {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLegacy.psd1 -Force
        Initialize-LegacySqlPackage -Path 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\SqlPackage.exe'
    }

    Context SqlInstance {

        BeforeEach {
            $SqlInstance = New-SqlTestInstance
            $SqlConnection = $SqlInstance | Connect-TSqlInstance
        }

        AfterEach {
            if ( $SqlConnection ) {
                $SqlConnection | Disconnect-TSqlInstance
            }
            if ( $SqlInstance ) {
                $SqlInstance | Remove-SqlTestInstance
            }
        }

        Context Publish {
            it works {
                $DatabaseName = ( [string](New-Guid) ).Substring(0, 8)

                Invoke-LegacySqlPackage -Publish `
                    -TargetServerName $ServerInstance `
                    -TargetDatabaseName $DatabaseName `
                    -DacPac $PSScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac `
                    -ErrorAction Stop
            }
        }

        Context Extract {

            BeforeAll {
                $DatabaseName = ( [string](New-Guid) ).Substring(0, 8)
                Invoke-LegacySqlPackage -Publish `
                    -TargetServerName $ServerInstance `
                    -TargetDatabaseName $DatabaseName `
                    -DacPac $PSScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac `
                    -ErrorAction Stop
            }

            it works {
                Invoke-LegacySqlPackage -Extract `
                    -SourceServerName $ServerInstance `
                    -SourceDatabaseName $DatabaseName `
                    -DacPac $PsScriptRoot/test.dacpac `
                    -ErrorAction Stop

                "$PsScriptRoot/test.dacpac" | Should -Exist
            }
        }
    }
}
