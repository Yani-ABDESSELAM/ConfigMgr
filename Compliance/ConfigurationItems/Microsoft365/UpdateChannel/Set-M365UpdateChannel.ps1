# Microsoft 365 | Update Channel Configuration

# Author:       Cameron Kollwitz <cameron@kollwitz.us>
# Date:         2020-06-16
# Description:  Configures the Microsoft 365 Update Channel on the device.
# Filename:     Set-M365UpdateChannel.ps1

## Specify the Update Channel
# List of the Update Channels: <https://docs.microsoft.com/en-us/deployoffice/office-deployment-tool-configuration-options#channel-attribute-part-of-updates-element>
$UpdateChannelName = "SemiAnnual" # Valid options are: MonthlyEnterprise, Current, CurrentPreview, SemiAnnual, SemiAnnualPreview, BetaChannel
Switch ($UpdateChannelName) {
  "MonthlyEnterprise" {
    # Monthly Enterprise Channel
    $UpdateChannel = "http://officecdn.microsoft.com/pr/55336b82-a18d-4dd6-b5f6-9e5095c314a6"
  }
  "Current" {
    # Current Channel
    $UpdateChannel = "http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60"
  }
  "CurrentPreview" {
    # Current (Preview) Channel
    $UpdateChannel = "http://officecdn.microsoft.com/pr/64256afe-f5d9-4f86-8936-8840a6a4f5be"
  }
  "SemiAnnual" {
    # Semi-Annual Enterprise Channel
    $UpdateChannel = "http://officecdn.microsoft.com/pr/7ffbc6bf-bc32-4f92-8982-f9dd17fd3114"
  }
  "SemiAnnualPreview" {
    # Semi-Annual Enterprise (Preview) Channel
    $UpdateChannel = "http://officecdn.microsoft.com/pr/b8f9b850-328d-4355-9145-c59439a0c4cf"
  }
  "BetaChannel" {
    # Beta Channel (AKA: InsidersFast)
    $UpdateChannel = "http://officecdn.microsoft.com/pr/5440fd1f-7ecb-4221-8110-145efaa6372f"
  }
}

# Update Device's Update Channel if it does not match the selection
Write-Output -InputObject "Update Channel '$($UpdateChannelName)' Selected; URI is $($UpdateChannel)"

# Common Variables
$OfficeC2RClientPath = Join-Path -Path $env:CommonProgramW6432 -ChildPath "Microsoft Shared\ClickToRun\OfficeC2RClient.exe"
$C2RConfiguration = "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration"
$CurrentUpdateChannel = Get-ItemProperty -Path $C2RConfiguration | Select-Object -ExpandProperty CDNBaseUrl

# Main Loop
If ($CurrentUpdateChannel -notlike $UpdateChannel) {
  Write-Output -InputObject "Device's Update Channel is incorrect! Remediating..."

  # Update Registy configuration for the new Update Channel
  Set-ItemProperty -Path $C2RConfiguration -Name "UpdateChannel" -Value $UpdateChannel -Force
  Write-Output -InputObject "Updated Registry with new Update Channel URI!"

  # Call OfficeC2RClient.exe and change the Update Channel
  ## NOT SURE IF WE STILL NEED TO DO THIS???
  $OfficeC2RClientParameters = "/changesetting channel=$($UpdateChannelName)"
  Write-Output -InputObject "Calling OfficeC2RClient.exe with the following parameters: $($OfficeC2RClientParameters)"
  Start-Process -FilePath $OfficeC2RClientPath -ArgumentList $OfficeC2RClientParameters -Wait

  # Call OfficeC2RClient.exe and Update all Microsoft 365 Applications
  ## NOT SURE IF WE STILL NEED TO DO THIS???
  $OfficeC2RClientParameters = "/update user updateprompt=false forceappshutdown=true displaylevel=true"
  Write-Output -InputObject "Calling OfficeC2RClient.exe with the following parameters: $($OfficeC2RClientParameters)"
  Start-Process -FilePath $OfficeC2RClientPath -ArgumentList $OfficeC2RClientParameters

  # Trigger ConfigMgr Hardware Inventory
  Invoke-WmiMethod -Namespace "root\ccm" -Class "SMS_Client" -Name "TriggerSchedule" -ArgumentList "{00000000-0000-0000-0000-000000000001}"
}
Else {
  # Device is already on the correct Update Channel
  Write-Output -InputObject "Current Update Channel matches selected Update Channel! Nothing to do."
}
