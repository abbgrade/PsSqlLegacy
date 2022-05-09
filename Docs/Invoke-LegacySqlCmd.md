---
external help file: PsSqlLegacy-help.xml
Module Name: PsSqlLegacy
online version: https://docs.microsoft.com/de-de/sql/tools/sqlcmd-utility?view=sql-server-ver15
schema: 2.0.0
---

# Invoke-LegacySqlCmd

## SYNOPSIS
Executes SQLCMD

## SYNTAX

### File
```
Invoke-LegacySqlCmd -InputFile <FileInfo> -ServerInstance <String> [-DatabaseCredential <PSCredential>]
 [-WindowsCredential <PSCredential>] [-AccessToken <String>] [-DatabaseName <String>] [-ErrorLevel <Int32>]
 [-ErrorSeverityLevel <Int32>] [-TerminateOnError] [-Timeout <Int32>] [-Variables <Hashtable>]
 [<CommonParameters>]
```

### Command
```
Invoke-LegacySqlCmd -Command <String> -ServerInstance <String> [-DatabaseCredential <PSCredential>]
 [-WindowsCredential <PSCredential>] [-AccessToken <String>] [-DatabaseName <String>] [-ErrorLevel <Int32>]
 [-ErrorSeverityLevel <Int32>] [-TerminateOnError] [-Timeout <Int32>] [-Variables <Hashtable>]
 [<CommonParameters>]
```

## DESCRIPTION
Wrapper tp the commandline tool SQLCMD.
It provides parameter validation, output and error handling.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -InputFile
Path to the executed SQL script file.

```yaml
Type: FileInfo
Parameter Sets: File
Aliases: File

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Command
Executed SQL script source.

```yaml
Type: String
Parameter Sets: Command
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerInstance
Name of the SQL Server Instance.

```yaml
Type: String
Parameter Sets: (All)
Aliases: DataSource

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DatabaseCredential
{{ Fill DatabaseCredential Description }}

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WindowsCredential
{{ Fill WindowsCredential Description }}

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AccessToken
{{ Fill AccessToken Description }}

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

### -DatabaseName
Name fo the SQL Database.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Database

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ErrorLevel
Minimum event severity to include in output.

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

### -ErrorSeverityLevel
Minimum event severity to interpret as error.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -TerminateOnError
Flag if a error must terminate the execution.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Timeout in seconds for the execution.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: ConnectionTimeout

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Variables
Values for variables, used in the script.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Check https://github.com/abbgrade/PsSqlClient and https://github.com/abbgrade/PsSmo if one of them already supports your use case.
They provide better PowerShell integration.

## RELATED LINKS

[https://docs.microsoft.com/de-de/sql/tools/sqlcmd-utility?view=sql-server-ver15](https://docs.microsoft.com/de-de/sql/tools/sqlcmd-utility?view=sql-server-ver15)

