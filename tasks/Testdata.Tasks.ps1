. $PSScriptRoot/PsSqlTestTasks/SqlServerSamples.Tasks.ps1
. $PSScriptRoot/PsSqlTestTasks/WideWorldImporters.Tasks.ps1
. $PSScriptRoot/PsSqlTestTasks/AdventureWorks.Tasks.ps1

task Testdata.Create -Jobs PsSqlTestTasks.AdventureWorks.CheckoutDirectory, PsSqlTestTasks.WideWorldImporters.DacPac.Create
