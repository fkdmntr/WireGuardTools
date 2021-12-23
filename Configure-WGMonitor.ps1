if (!(Test-Path -Path C:\CTeq)){
    New-Item -Path "C:\" -Name "CTeq" -ItemType Directory
}
If ([System.Environment]::Is64BitOperatingSystem) {
    Copy-Item -Path ".\nssm64.exe" -Destination "C:\Cteq\nssm.exe"
}
ElseIf (![System.Environment]::Is64BitOperatingSystem) {
    Copy-Item -Path ".\nssm32.exe" -Destination "C:\Cteq\nssm.exe"
}
Copy-Item -Path ".\Watch-WireGuardTunnel.ps1" -Destination "C:\CTeq\Watch-WireGuardTunnel.ps1"
Copy-Item -Path ".\AClay.Cteq.CodeSigning.cer" -Destination "C:\Cteq\AClay.Cteq.CodeSigning.cer"
Import-Certificate -FilePath "C:\CTeq\AClay.Cteq.CodeSigning.cer" -CertStoreLocation "Cert:\LocalMachine\Root\"
Import-Certificate -FilePath "C:\CTeq\AClay.Cteq.CodeSigning.cer" -CertStoreLocation "Cert:\LocalMachine\TrustedPublisher\"
Set-Location -Path "C:\CTeq"
Start-Process -FilePath "C:\CTeq\nssm.exe" -ArgumentList "install WireGuardMonitor powershell.exe /executionpolicy AllSigned C:\Cteq\Watch-WireGuardTunnel.ps1 -WGTunnelName WandLink" -Verb runAs
do {$WGMonitorService = Get-Service WireGuardMonitor} until ($null -ne $WGMonitorService)
Start-Process -FilePath "C:\CTeq\nssm.exe" -ArgumentList "set WireGuardMonitor AppDirectory C:\Cteq" -Verb runAs
Start-Sleep -seconds 5
Start-service WireGuardMonitor
Remove-Item -Path "C:\CTeq\AClay.Cteq.CodeSigning.cer"