# Set All CM Collections to 7 Day Simple Refresh Interval!

# Set the CM Schedule Token
#$Schedule = New-CMSchedule -Start "11/28/2012 11:00 PM" -RecurInterval Days -RecurCount 7
#$Schedule = New-CMSchedule -Start "11/28/2012 11:00 PM" -RecurInterval Hours -RecurCount 4

# Use this one for the following Collections: 'All Desktop and Server Clients', 'All Mobile Devices', 'All Systems', 'All Unknown Computers', 'OSD - PXE Boot'
$Schedule = New-CMSchedule -Start "11/28/2012 11:00 PM" -RecurInterval Hours -RecurCount 4

# 'All Desktop and Server Clients', 'All Mobile Devices', 'All Systems', 'All Unknown Computers', 'OSD - PXE Boot'
Set-CMCollection -Name 'All Desktop and Server Clients' -RefreshSchedule $Schedule -ForceWildcardHandling -Verbose
Set-CMCollection -Name 'All Mobile Devices' -RefreshSchedule $Schedule -ForceWildcardHandling -Verbose
Set-CMCollection -Name 'All Systems' -RefreshSchedule $Schedule -ForceWildcardHandling -Verbose
Set-CMCollection -Name 'All Unknown Computers' -RefreshSchedule $Schedule -ForceWildcardHandling -Verbose
Set-CMCollection -Name 'OSD - PXE Boot' -RefreshSchedule $Schedule -ForceWildcardHandling -Verbose

# Perform the Change (Generally)
#Set-CMCollection -Name '*' -RefreshSchedule $Schedule -ForceWildcardHandling -Verbose
