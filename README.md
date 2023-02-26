# Readme

PsSqlLegacy is a PowerShell wrapper for the SQL Server tools SqlCmd and SqlPackage.

For details, visit the [GitHub Pages](https://abbgrade.github.io/PsSqlLegacy/).

## Usage

See [the command reference](./docs/) for descriptions and examples.

## Changelog

See the [changelog](./CHANGELOG.md) file.

## Installation

This module can be installed from [PsGallery](https://www.powershellgallery.com/packages/PsSqlLegacy).

```powershell
Install-Module -Name PsSqlLegacy -AllowPrerelease
```

Alternatively it can be built and installed from the sources:

1. Install the development dependencies
2. Download or clone it from GitHub
3. Run the installation task:

```powershell
Invoke-Build Install
```

## Development

- This is a [Portable Module](https://docs.microsoft.com/de-de/powershell/scripting/dev-cross-plat/writing-portable-modules?view=powershell-7).
- [VSCode](https://code.visualstudio.com) is recommended as IDE. [VSCode Tasks](https://code.visualstudio.com/docs/editor/tasks) are configured.
- Build automation is based on [InvokeBuild](https://github.com/nightroman/Invoke-Build)
- Test automation is based on [Pester](https://pester.dev)
- Commands are named based on [Approved Verbs for PowerShell Commands](https://docs.microsoft.com/de-de/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands)
- This project uses [git-flow](https://github.com/nvie/gitflow).
- This project uses [keep a changelog](https://keepachangelog.com/en/1.0.0/).

### Build

The build scripts require InvokeBuild. If it is not installed, install it with the command `Install-Module InvokeBuild -Scope CurrentUser`.

You can build the module using the VS Code build task or with the command `Invoke-Build Build`.

### Release

1. Create a release branch using git-flow.
2. Update the version number in the module manifest.
3. Extend the changelog in this readme.
4. If you want to create a pre-release.
   1. Push the release branch to GitHub, to publish the pre-release to PsGallery.
5. Finish release using git-flow.
6. Check if tags are not pushed to GitHub.
7. Check if the release branch is deleted on GitHub.
8. Create the release on GitHub.
