---
external help file: PsSqlLegacy-help.xml
Module Name: PsSqlLegacy
online version: https://docs.microsoft.com/de-de/sql/tools/sqlpackage?view=sql-server-ver15
schema: 2.0.0
---

# Invoke-LegacySqlPackage

## SYNOPSIS
Executes SQLCMD

## SYNTAX

### Script
```
Invoke-LegacySqlPackage -Script <String> [-TargetUser <String>] [-TargetPassword <String>]
 [-SourceUser <String>] [-SourcePassword <String>] [-AccessToken <String>] [-AzureSql]
 [-InteractiveAuthentication] [-DropConstraintsNotInSource <Boolean>] [-DropDmlTriggersNotInSource <Boolean>]
 [-DropExtendedPropertiesNotInSource <Boolean>] [-DropIndexesNotInSource <Boolean>]
 [-DropObjectsNotInSource <Boolean>] [-DropPermissionsNotInSource <Boolean>]
 [-DropRoleMembersNotInSource <Boolean>] [-DropStatisticsNotInSource <Boolean>] [-Timeout <Int32>]
 [-Variables <Hashtable>] [<CommonParameters>]
```

### Publish
```
Invoke-LegacySqlPackage [-Publish] -DacPac <FileInfo> -TargetServerName <String> [-TargetUser <String>]
 [-TargetPassword <String>] -TargetDatabaseName <String> [-SourceUser <String>] [-SourcePassword <String>]
 [-AccessToken <String>] [-AzureSql] [-InteractiveAuthentication] [-DropConstraintsNotInSource <Boolean>]
 [-DropDmlTriggersNotInSource <Boolean>] [-DropExtendedPropertiesNotInSource <Boolean>]
 [-DropIndexesNotInSource <Boolean>] [-DropObjectsNotInSource <Boolean>]
 [-DropPermissionsNotInSource <Boolean>] [-DropRoleMembersNotInSource <Boolean>]
 [-DropStatisticsNotInSource <Boolean>] [-Timeout <Int32>] [-Variables <Hashtable>] [-Force]
 [<CommonParameters>]
```

### Extract
```
Invoke-LegacySqlPackage [-Extract] [-DacPac <FileInfo>] [-TargetUser <String>] [-TargetPassword <String>]
 -SourceServerName <String> [-SourceUser <String>] [-SourcePassword <String>] [-AccessToken <String>]
 -SourceDatabaseName <String> [-AzureSql] [-InteractiveAuthentication] [-DropConstraintsNotInSource <Boolean>]
 [-DropDmlTriggersNotInSource <Boolean>] [-DropExtendedPropertiesNotInSource <Boolean>]
 [-DropIndexesNotInSource <Boolean>] [-DropObjectsNotInSource <Boolean>]
 [-DropPermissionsNotInSource <Boolean>] [-DropRoleMembersNotInSource <Boolean>]
 [-DropStatisticsNotInSource <Boolean>] [-Timeout <Int32>] [-Variables <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
Wrapper tp the commandline tool SQLPACKAGE.
It provides parameter validation, output and error handling.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Script
Flag if a install script should be created.

```yaml
Type: String
Parameter Sets: Script
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Publish
Flag if a database should be published.

```yaml
Type: SwitchParameter
Parameter Sets: Publish
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Extract
{{ Fill Extract Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Extract
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DacPac
Path to the dacpac file.
\[ValidateScript({ $_.Exists })\]

```yaml
Type: FileInfo
Parameter Sets: Publish
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: FileInfo
Parameter Sets: Extract
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetServerName
Name of the SQL Server Instance to publish the dacpac to.

```yaml
Type: String
Parameter Sets: Publish
Aliases: ServerInstance, DataSource

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TargetUser
Username for the login.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Username

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TargetPassword
Password for the login.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Password

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TargetDatabaseName
Name of the SQL database to publish the dacpac to.

```yaml
Type: String
Parameter Sets: Publish
Aliases: DatabaseName, Database

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SourceServerName
Name of the SQL Server Instance to publish the dacpac to.

```yaml
Type: String
Parameter Sets: Extract
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SourceUser
Username for the login.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SourcePassword
Password for the login.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AccessToken
AccessToken for the login

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SourceDatabaseName
Name of the SQL database to publish the dacpac to.

```yaml
Type: String
Parameter Sets: Extract
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AzureSql
Flag if the SQL Server is a Azure SQL Server.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -InteractiveAuthentication
Flag if interactive authentication is used.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DropConstraintsNotInSource
Flag if surplus contraints should be dropped.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DropDmlTriggersNotInSource
Flag if surplus triggers should be dropped.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DropExtendedPropertiesNotInSource
Flag if surplus properties should be dropped.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DropIndexesNotInSource
Flag if surplus indices should be dropped.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DropObjectsNotInSource
Flag if surplus objects should be dropped.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DropPermissionsNotInSource
Flag if surplus permissions should be dropped.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DropRoleMembersNotInSource
Flag if surplus role members should be dropped.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DropStatisticsNotInSource
Flag if surplus statistics should be dropped.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Timeout is seconds for the execution.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Variables
Values for the variables used in the dacpac.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @{}
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Force the action and accept the risk of data loss.

```yaml
Type: SwitchParameter
Parameter Sets: Publish
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Check https://github.com/abbgrade/PsDac and https://github.com/abbgrade/PsSmo if one of them already supports your use case.
They provide better PowerShell integration.

## RELATED LINKS

[https://docs.microsoft.com/de-de/sql/tools/sqlpackage?view=sql-server-ver15](https://docs.microsoft.com/de-de/sql/tools/sqlpackage?view=sql-server-ver15)

