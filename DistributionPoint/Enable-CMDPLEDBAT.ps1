# Quick One-Liner to Globally Enable LEDBAT on Distribution Points
# Requires Windows Server 2016+!
Get-CMDistributionPoint | Set-CMDistributionPoint -EnableLedbat $true
