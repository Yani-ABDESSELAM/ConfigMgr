# Invoke-CMMessageQueueCleanup.ps1
# Description: Will remove all 

([wmiclass]"ROOT\ccm:SMS_Client").GetAssignedSite().sSiteCode

([wmi]"ROOT\ccm:SMS_Client=@").ClientVersion
 
([wmiclass]"ROOT\ccm:SMS_Client").GetAssignedSite().sSiteCode
 
([wmi]"ROOT\ccm:SMS_Authority.Name='SMS:SEA'").CurrentManagementPoint
 
Get-WmiObject -query "SELECT * FROM Win32_Service WHERE Name ='CcmExec'" -namespace "ROOT\cimv2"
 
(Get-Service 'CcmExec').Stop()
 
(Get-Service 'CcmExec').Status
 
(Get-WmiObject Win32_Processor | Where-Object { $_.DeviceID -eq 'CPU0' }).AddressWidth
 
([wmi]"ROOT\ccm:SMS_Client=@").ClientVersion
 
(Get-ItemProperty("HKLM:\SOFTWARE\Microsoft\SMS\Client\Configuration\Client Properties")).$("Local SMS Path")
 
Get-ChildItem 'C:\Windows\CCM\ServiceData\Messaging\EndpointQueues' -include *.msg, *.que -recurse | foreach ($_) { remove-item $_.fullname -force }
 
Get-WmiObject -query "SELECT * FROM Win32_Service WHERE Name ='CcmExec'" -namespace "ROOT\cimv2"
 
(Get-Service 'CcmExec').Start()
 
(Get-Service 'CcmExec').Status
 
([wmiclass]'ROOT\ccm:SMS_Client').TriggerSchedule('{00000000-0000-0000-0000-000000000112}')
