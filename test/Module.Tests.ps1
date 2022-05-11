Describe PsSqlLegacy {

    It 'is valid' {
        Test-ModuleManifest $PSScriptRoot\..\Source\PsSqlLegacy.psd1
    }

    It 'can be imported' {
        $module = Import-Module $PSScriptRoot\..\Source\PsSqlLegacy.psd1 -Force -PassThru
        $module | Should -Not -BeNullOrEmpty
    }

    Context 'loaded modules' {
        BeforeAll {
            Import-Module $PSScriptRoot\..\Source\PsSqlLegacy.psd1 -Force
        }

        It 'has commands' {
            $commands = Get-Command -Module PsSqlLegacy
            $commands | Should -Not -BeNullOrEmpty
            $commands.Count | Should -Be 4
        }
    }
}
