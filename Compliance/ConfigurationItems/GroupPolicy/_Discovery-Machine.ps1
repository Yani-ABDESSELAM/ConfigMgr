# Configuration Item: Detect Broken Group Policy (Machine)
# _Discovery.ps1

# Author: Cameron Kollwitz
# Date: Jun 11, 2020

# Group Policy Files that are more than 1-day old will evaluate as 'Non-Compliant'.
# All dates in 'yyyyMMdd' format because *REASONS*!

# Policy files older than 1-day will be evaluated as 'Non-Compliant'!
$TargetDate = (Get-Date).AddDays(-1).ToString('yyyyMMdd')

## Machine Policy Compliance Check
$MachinePolicyDate = (Get-ChildItem C:\Windows\System32\GroupPolicy\Machine\Registry.pol).CreationTime.ToString('yyyyMMdd')
If ($MachinePolicyDate -ge $TargetDate) { Write-Host "Compliant" } Else { Write-Host "Non-Compliant" }
