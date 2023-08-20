<#
.SYNOPSIS
This script is used to package a UiPath project to the Orchestrator package format.

.DESCRIPTION
Requires UiPath CLI installed.

.PARAMETER ProjectPath
The path to the UiPath project to be packaged.

.PARAMETER OutPath
The path to where the resulting package will be placed.

.PARAMETER Version
The version of the package.

#>

param (
	[Parameter(Mandatory=$true)][string]$ProjectPath,
	[Parameter(Mandatory=$true)][string]$OutPath,
	[Parameter(Mandatory=$true)][string]$Version
)

#Log function
function WriteLog
{
	Param ($message, [switch] $err)
	
	$now = Get-Date -Format "G"
	$line = "$now`t$message"
	$line | Add-Content $debugLog -Encoding UTF8
	if ($err)
	{
		Write-Host $line -ForegroundColor red
	} else {
		Write-Host $line
	}
}

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$debugLog = "$scriptPath\orchestrator-package-pack.log"
$cliVersion = "22.10.8438.32859"
$uipathCLI = "$scriptPath\uipathcli\$cliVersion\tools\uipcli.exe"

# Check if UiPath CLI exists, if not, exit with an error message.
if (-not(Test-Path -Path $uipathCLI -PathType Leaf)) {
    WriteLog "UiPath CLI does not exist at the expected location: $uipathCLI. Please make sure it's installed and the path is correct." -err
    exit 1
}
WriteLog "UiPath CLI is ready at location: $uipathCLI"

try
{
	# Pack the project
	WriteLog "Packing project located at $ProjectPath"
	& $uipathCLI pack project -p $ProjectPath -o $OutPath -v $Version
	WriteLog "Packing completed. Package is located at $OutPath"
}
catch
{
	WriteLog ("Error Occured : " + $_.Exception.Message) -err $_.Exception
	exit 1
}