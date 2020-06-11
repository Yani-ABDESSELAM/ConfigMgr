# Configuration Item: Detect Broken Group Policy (User)
# _Remediation.ps1

# Author: Cameron Kollwitz
# Date: Jun 11, 2020

# Removes the broken Group Policy file and triggers a Group Policy update on the device.
Remove-Item C:\Windows\System32\GroupPolicy\User\Registry.pol -Force -Verbose
Write-Host y | Invoke-GPUpdate -Force
