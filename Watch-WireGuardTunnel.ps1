#variables
param(
    [Parameter(Mandatory=$true)]
    [String]$WGTunnelName,
    [Parameter(Mandatory=$false)]
    [String]$CheckInterval = "180",
    [Parameter(Mandatory=$false)]
    [String]$WireGuardExePath="C:/Program Files/WireGuard/wireguard.exe"
)
$WGTunnelServiceName = "WireGuardTunnel`$$WGtunnelName"
$WGManagerServiceName = "WireGuardManager"
Function Test-WGManager {
    $WgManagerService = Get-Service -Name $WGManagerServiceName
    If (!$WgManagerService.StartType -eq "Automatic") {
        Set-Service -Name $WGManagerServiceName -StartupType "Automatic"
    }
    If (!$WgManagerService.Status -eq "Running") {
        Start-Service -Name $WGManagerServiceName
    }   
}
Function Test-WgTunnel {
    $WgTunnelService = Get-Service -Name $WGTunnelServiceName
    If ($null -eq $WgTunnelService){
        $WgArgs = '/installtunnelservice ' + "`"C:\Program Files\WireGuard\Data\Configurations\$($WgTunnelName).conf.dpapi`""
        Start-Process -FilePath $WireGuardExePath -ArgumentList $WgArgs -verb runAs
    }
}
Do{
Test-WGManager
Test-WgTunnel
Start-Sleep -Seconds $CheckInterval