Describe PsPowerBi {
    It 'is valid' {
        Test-ModuleManifest $PSScriptRoot\..\Source\PsSqlLegacy.psd1
    }

    It 'can be imported' {
        Import-Module $PSScriptRoot\..\Source\PsSqlLegacy.psd1 -Force
    }

    Context 'loaded modules' {
        BeforeAll {
            Import-Module $PSScriptRoot\..\Source\PsSqlLegacy.psd1 -Force -Verbose
        }

        It 'has commands' {
            $commands = Get-Command -Module 'PsSqlLegacy'
            $commands | Should -Not -BeGreaterOrEqual
        }
    }
}
