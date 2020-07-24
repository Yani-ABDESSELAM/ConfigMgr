# Gather Scheduled Task Variables...
$taskname = "Daily Reboot (Conference Rooms)"
$description = "Version 1.0 - CHG0030473"
$command = "%SystemRoot%\system32\shutdown.exe"
$actionArguments = "-r -t 60 -c `"This device is performing its scheduled daily reboot in 60 seconds.`" -f"
$action = New-ScheduledTaskAction -Execute $command -Argument $actionArguments
$Triggers = @()
$triggers += New-ScheduledTaskTrigger -Daily -At 12:00
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -WakeToRun
$principle = New-ScheduledTaskPrincipal -GroupId "NT AUTHORITY\SYSTEM"
$inputObject = New-ScheduledTask -Action $action -Description $description -Trigger $triggers -Settings $settings -Principal $principle

# Install the Scheduled Task on the device
Register-ScheduledTask $taskname -InputObject $inputObject -Force
