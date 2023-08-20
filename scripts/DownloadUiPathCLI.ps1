# DownloadUiPathCLI.ps1

param (
    [string] $cliVersion = "22.10.8438.32859", #CLI Version (Script was tested on this latest version at the time)
    [string] $downloadPath = (Split-Path -Parent $MyInvocation.MyCommand.Path)
)

function WriteLog {
    Param ($message, [switch] $err)

    $now = Get-Date -Format "G"
    $line = "$now`t$message"
    $line | Add-Content "$downloadPath\orchestrator-package-pack.log" -Encoding UTF8

    if ($err) {
        Write-Host $line -ForegroundColor red
    } else {
        Write-Host $line
    }
}

$uipathCLI = "$downloadPath\uipathcli\$cliVersion\tools\uipcli.exe"
if (-not(Test-Path -Path $uipathCLI -PathType Leaf)) {
    WriteLog "UiPath CLI does not exist in this folder. Location: $uipathCLI. Attempting to download it..."
    try {
        if (-not(Test-Path -Path "$downloadPath\uipathcli\$cliVersion" -PathType Leaf)){
            New-Item -Path "$downloadPath\uipathcli\$cliVersion" -ItemType "directory" -Force | Out-Null
        }

        #Download UiPath CLI
        Invoke-WebRequest "https://uipath.pkgs.visualstudio.com/Public.Feeds/_apis/packaging/feeds/1c781268-d43d-45ab-9dfc-0151a1c740b7/nuget/packages/UiPath.CLI.Windows/versions/$cliVersion/content" -OutFile "$downloadPath\\uipathcli\\$cliVersion\\cli.zip"
        
        Expand-Archive -LiteralPath "$downloadPath\\uipathcli\\$cliVersion\\cli.zip" -DestinationPath "$downloadPath\\uipathcli\\$cliVersion"
        WriteLog "UiPath CLI is downloaded and extracted in folder $downloadPath\uipathcli\\$cliVersion"
    } catch {
        WriteLog ("Error Occured : " + $_.Exception.Message) -err $_.Exception
        exit 1
    }
}

WriteLog "-----------------------------------------------------------------------------"
WriteLog "uipcli location :   $uipathCLI"