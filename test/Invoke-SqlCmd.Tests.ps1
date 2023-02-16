#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }, @{ ModuleName='PsSqlTestServer'; ModuleVersion='1.4.0' }

Describe Invoke-SqlCmd {

    BeforeAll {
        Import-Module $PSScriptRoot\..\src\PsSqlLegacy.psd1 -Force
        Initialize-LegacySqlCmd ( where.exe sqlcmd | Select-Object -First 1 )
    }

    It Exists {
        Get-Command -Name Invoke-LegacySqlCmd -Module PsSqlLegacy | Should -Not -BeNullOrEmpty
    }

    Context Database {

        BeforeAll {
            $TestServer = New-SqlTestDockerInstance -AcceptEula
        }

        AfterAll {
            if ( $TestServer ) {
                $TestServer | Remove-SqlTestDockerInstance
            }
        }

        Context adventure-works {

            BeforeAll {
                [System.IO.FileInfo] $InstallScript = "$PSScriptRoot\sql-server-samples\samples\databases\adventure-works\oltp-install-script\instawdb.sql"
                [System.IO.DirectoryInfo] $SqlSamplesSourceDataPath = "$( $InstallScript.Directory )\"

                #Remove static variable assignments from install script
                $ModifiedInstallScript = Join-Path TestDrive: instawdb.sql
                Get-Content -Path $InstallScript | Where-Object {
                    $_ -notlike '*:setvar*'
                } | Set-Content -Path $ModifiedInstallScript
                $ModifiedInstallScript = Get-Item $ModifiedInstallScript
            }

            BeforeEach {
                $DatabaseName = New-SqlTestDatabaseName -Prefix AdventureWorks
            }

            It Works {
                Invoke-LegacySqlCmd -Verbose `
                    -InputFile $ModifiedInstallScript `
                    -ServerInstance $TestServer.DataSource `
                    -DatabaseCredential $TestServer.DatabaseCredential `
                    -TerminateOnError `
                    -Variables @{
                        SqlSamplesSourceDataPath = $SqlSamplesSourceDataPath
                        DatabaseName             = $DatabaseName
                    }
            }
        }
    }
}
