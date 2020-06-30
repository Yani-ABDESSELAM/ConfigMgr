# Uninstall the CM Client from the device (silent)
Try {
  Write-Host "The uninstall process is silent by design. Right after you execute the command run Task Manager (Ctrl + Shift + Esc) in Details tab you will see new process running ccmsetup.exe. After couple of minutes process CcmExec.exe will disappear. When process ccmsetup.exe disappears the uninstallation process will be finished!"
  Start-Process -FilePath "C:\Windows\ccmsetup\ccmsetup.exe" -ArgumentList "/uninstall"
}
Catch { 
  Write-Host "Something went wrong uninstalling the ConfigMgr Client!"
}

# Wait for the ConfigMgr Client to be uninstalled
Write-Host "Waiting 60 seconds for the ConfigMgr Client to uninstall..."
Start-Sleep -Seconds 60

# Stop the Service "SMS Agent Host" which is a Process "CcmExec.exe"
Write-Host "Stop the SMS Agent Host (CcmExec.exe)"
Get-Service -Name CcmExec -ErrorAction SilentlyContinue | Stop-Service -Force -Verbose

# Stop the Service "ccmsetup" which is also a Process "ccmsetup.exe" if it wasn't stopped in the services after uninstall
Write-Host "Stop the Service and Process ccmexec..."
Get-Service -Name ccmsetup -ErrorAction SilentlyContinue | Stop-Service -Force -Verbose

# Delete the folder of the ConfigMgr Client installation: "C:\Windows\CCM"
Write-Host "Remove CCM Folder..."
Remove-Item -Path "$($Env:WinDir)\CCM" -Force -Recurse -Confirm:$false -Verbose

# Delete the folder of the ConfigMgr Client Cache of all the packages and Applications that were downloaded and installed on the Computer: "C:\Windows\ccmcache"
Write-Host "Purge device of ConfigMgr Client Setup Files..."
Remove-Item -Path "$($Env:WinDir)\CCMSetup" -Force -Recurse -Confirm:$false -Verbose

# Delete the folder of the ConfigMgr Client Setup files that were used to install the client: "C:\Windows\ccmsetup"
Write-Host "Purge device of ConfigMgr Client cache, downloaded content, etc...."
Remove-Item -Path "$($Env:WinDir)\CCMCache" -Force -Recurse -Confirm:$false -Verbose

# Delete the file with the certificate GUID and SMS GUID that current Client was registered with
Write-Host "Delete the certificate GUID and SMS GUID that current Client was registered with..."
Remove-Item -Path "$($Env:WinDir)\smscfg.ini" -Force -Confirm:$false -Verbose

# Delete the certificate itself
Write-Host "Purge the SMS Certificates..."
Remove-Item -Path 'HKLM:\Software\Microsoft\SystemCertificates\SMS\Certificates\*' -Force -Confirm:$false -Verbose

# Remove all the registry keys associated with the ConfigMgr Client that might not be removed by ccmsetup.exe
Write-Host "Purge the SMS Registry Entries..."
Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\CCM' -Force -Recurse -Verbose
Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\CCM' -Force -Recurse -Confirm:$false -Verbose
Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\SMS' -Force -Recurse -Confirm:$false -Verbose
Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\SMS' -Force -Recurse -Confirm:$false -Verbose
Remove-Item -Path 'HKLM:\Software\Microsoft\CCMSetup' -Force -Recurse -Confirm:$false -Verbose
Remove-Item -Path 'HKLM:\Software\Wow6432Node\Microsoft\CCMSetup' -Force -Confirm:$false -Recurse -Verbose

# Remove the service from "Services"
Write-Host "Purge the SMS Serivces..."
Remove-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\CcmExec' -Force -Recurse -Confirm:$false -Verbose
Remove-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\ccmsetup' -Force -Recurse -Confirm:$false -Verbose

# Remove the Namespaces from the WMI repository
Write-Host "Purge the SMS WMI Repository..."
Get-CimInstance -query "Select * From __Namespace Where Name='CCM'" -Namespace "root" | Remove-CimInstance -Verbose -Confirm:$false
Get-CimInstance -query "Select * From __Namespace Where Name='CCMVDI'" -Namespace "root" | Remove-CimInstance -Verbose -Confirm:$false
Get-CimInstance -query "Select * From __Namespace Where Name='SmsDm'" -Namespace "root" | Remove-CimInstance -Verbose -Confirm:$false
Get-CimInstance -query "Select * From __Namespace Where Name='sms'" -Namespace "root\cimv2" | Remove-CimInstance -Verbose -Confirm:$false

# Alternative command for WMI Removal in case of something goes wrong with the above.
Write-Host "Purge the SMS WMI Repository (2nd Pass)..."
Get-WmiObject -query "Select * From __Namespace Where Name='CCM'" -Namespace "root" | Remove-WmiObject -Verbose | Out-Host
Get-WmiObject -query "Select * From __Namespace Where Name='CCMVDI'" -Namespace "root" | Remove-WmiObject -Verbose | Out-Host
Get-WmiObject -query "Select * From __Namespace Where Name='SmsDm'" -Namespace "root" | Remove-WmiObject -Verbose | Out-Host
Get-WmiObject -query "Select * From __Namespace Where Name='sms'" -Namespace "root\cimv2" | Remove-WmiObject -Verbose | Out-Host

# End of the line
Write-Host "The ConfigMgr Client has been purged from the system! A reboot is highly recommended!"
