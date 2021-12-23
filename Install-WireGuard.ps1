function Initialize-Vars {
    #OS is 64-bit or 32-bit?
    If ([System.Environment]::Is64BitOperatingSystem) {
        $Script:OsBitness = "64"
    }
    ElseIf (![System.Environment]::Is64BitOperatingSystem) {
        $Script:OsBitness = "32"
    }
    #Firewall Vars
    $Script:FirewallConfigFile = "FirewallRules.csv"
    #WgInstallVars
    $Script:WgWindowsClientURI = "https://download.wireguard.com/windows-client/"
    #WgInitializeVars
    $Script:WgConfigFile = "WandLink.conf"
    #WgSchedTaskVars
    $Script:WgTaskInterval
}
function Install-WireGuard {
    If ($Script:OsBitness = "64") {
        $Script:WGCurrentMSI = ((Invoke-WebRequest -Uri "$Script:WgWindowsClientURI" -UseBasicParsing).links | Where-Object -Property "href" -Match "amd64").href
        Invoke-WebRequest -Uri "$Script:WgWindowsClientURI$Script:WGCurrentMSI" -UseBasicParsing -OutFile $Script:WGCurrentMSI
        Start-Process -FilePath msiexec.exe -ArgumentList '/q', '/I', "$Script:WGCurrentMSI" -Wait -NoNewWindow -PassThru | Out-Null
    }
    ElseIf ($Script:OsBitness = "32") {
        $Script:WGCurrentMSI = ((Invoke-WebRequest -Uri "$Script:WgWindowsClientURI" -UseBasicParsing).links | Where-Object -Property "href" -Match "x86").href
        Invoke-WebRequest -Uri "$Script:WgWindowsClientURI"+"$Script:WGCurrentMSI" -UseBasicParsing -OutFile $Script:WGCurrentMSI
        Start-Process -FilePath msiexec.exe -ArgumentList '/q', '/I', "$Script:WGCurrentMSI" -Wait -NoNewWindow -PassThru | Out-Null
    }
}
function Initialize-Wireguard {
#toggle to import config, default to new config generation. Prompt for peer info & options
    Copy-Item -Path $Script:WgConfigFile -Destination "C:\Program Files\WireGuard\Data\Configurations"
    $Script:WgArgs = '/installtunnelservice ' + "`"C:\Program Files\WireGuard\Data\Configurations\$($Script:WgConfigFile).dpapi`""
    Start-Process -FilePath "C:/Program Files/WireGuard/wireguard.exe" -ArgumentList $Script:WgArgs -verb runAs
}
function Add-WgUpdateScript {
#generate script to check for updates, place in Wireguard program directory
}
function Install-WgMonitorService {
    #Task 1 - check WG link status at interval, start tunnel service if down
    $Script:WgTask1Name = "WireGuard.StatusCheck"
    $Script:WgTask1Description = "Check WG link status at interval, start tunnel service if down"
    
    #Task 2 - 
}
Initialize-Vars
Install-WireGuard
Initialize-Wireguard