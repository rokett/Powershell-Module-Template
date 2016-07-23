<#
.SYNOPSIS
Generates the folder and file structure needed to create a new Powershell module.

.DESCRIPTION
In order to provide some standardisation, this script will create the necessary folder/file structure for a new Powershell module.

The structure includes folders for Public and Private functions, creates a basic manifest file and root module loader, and creates a Pester test file for the manifest.

Once the environment is setup, proper development can begin.  Any public functions to be exported should still be added to the FunctionsToExport array in the manifest file.

Private functions are those which are internal to the module and are therefore not for public consumption.

Each public function should have its own test file in the Tests folder.

.PARAMETER ModuleName
The name you wish to give the module.  The root folder, manifest, and root loader will be named after the module.

.PARAMETER Author
Enter a name to be listed as the Author in the module manifest.

.PARAMETER Description
A short description of the module to be listed in the module manifest.

.PARAMETER PowershellVersion
The minimum version of Powershell supported by the module.  One of 2.0, 3.0 (the default), 4.0 or 5.0.

.PARAMETER ModulesPath
The full path to the directory you wish to develop the module in.  This is where the module structure will be created.
Include a trailing \ or don't, it doesn't matter.

.EXAMPLE
New-PSModule.ps1 -ModuleName WackyRaces -Author 'Penelope Pitstop' -Description 'Win the wacky races' -PowershellVersion '4.0' -ModulesPath 'c:\development\powershell-modules'
Creates a new module structure called WackyRaces in c:\development\powershell-modules\WackyRaces.  The module manifest will require Powershell v4.0.
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    [string]$ModuleName,

    [Parameter(Mandatory=$True)]
    [string]$Author,

    [Parameter(Mandatory=$True)]
    [string]$Description,

    [Parameter()]
    [ValidateSet('2.0','3.0','4.0','5.0')]
    [string]$PowershellVersion = '3.0',

    [Parameter(Mandatory=$True)]
    [string]$ModulesPath
)

if ($ModulesPath.Substring($ModulesPath.Length - 1) -ne '\') {
    $ModulesPath = $ModulesPath + '\'
}

$rootLoaderTemplate = $ModulesPath + '_Templates\Module.psm1'
$manifestTestFileTemplate = $ModulesPath + '_Templates\Module.Tests.ps1'

$moduleDir = $ModulesPath + $ModuleName
$publicDir = $moduleDir + '\Public'
$privateDir = $moduleDir + '\Private'
$testsDir = $moduleDir + '\Tests'

New-Item -Path $moduleDir -Type Directory
New-Item -Path $publicDir -Type Directory
New-Item -Path $privateDir -Type Directory
New-Item -Path $testsDir -Type Directory

$manifestTestFile = $testsDir + '\' + $ModuleName + '.Tests.ps1'
$manifestFile = $moduleDir + '\' + $ModuleName + '.psd1'
$rootLoader = $moduleDir + '\' + $ModuleName + '.psm1'

New-ModuleManifest -Path $ManifestFile -Author $Author -Description $Description -PowerShellVersion $PowershellVersion -RootModule $ModuleName

Copy-Item -Path $rootLoaderTemplate -Destination $rootLoader
Copy-Item -Path $manifestTestFileTemplate -Destination $manifestTestFile
