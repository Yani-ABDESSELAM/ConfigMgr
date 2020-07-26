$taskname = "Daily Reboot (Conference Rooms)"
$description = "Version 1.0 - CHG0030473"

# Evaluate if the device has the Scheduled Task installed on it by validating the Description text for the task.
$value = (Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue).Description

# $value should return the full description field if the task is installed, otherwise $null!
If ($value -eq $description) { 
  Return $True 
} Else {
  Return $False
}
