# Restart all Configuration Manager Distribution Points

$credential = (Get-Credential)
$CMDistributionPoints = (Read-Host -Prompt "Enter Distribution Point Name(s)")

Try {
  # Reboot the Configuration Manager Distribution Points!
  Restart-Computer "$CMDistributionPoints" -Credential $credential -Verbose -Force
} 
Catch {
  # Throw Error Message
  Write-Host 'ERROR: Something went wrong. Credentials?' -ForegroundColor 'Red'
}
Finally {
  # Let everyone know we're done
  Write-Host 'Jobs Done.' -ForegroundColor 'Green'
}
