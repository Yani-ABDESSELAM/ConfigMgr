# Function to set User Device Affinity

# Example
# .\Set-CMUserDeviceAffinity.ps1 -SiteCode SEA -SiteServer SEA-SCCM01 -ClientName DEVICENAME -Username "DOMAIN\Username"

Function Set-CMUserDeviceAffinity {
  [CmdletBinding()]  
  Param( 
    [Parameter(Mandatory = $True, HelpMessage = "Please Enter CM Site Server Site Code")]
    $SiteCode,
    [Parameter(Mandatory = $True, HelpMessage = "Please Enter CM Site Server Name")]
    $SiteServer,
    [Parameter(Mandatory = $True, HelpMessage = "Please Enter Device Name")]
    $ClientName,
    [Parameter(Mandatory = $True, HelpMessage = "Please Enter User Name")]
    $Username
  )

  $Class1 = "SMS_CombinedDeviceResources"
  $Class2 = "SMS_UserMachineRelationship"
  $Method = "CreateRelationship"
  $AffinityType = 2

  Try {
    $ResourceIDQuery = Get-WmiObject -Namespace "Root\SMS\Site_$SiteCode" -Class $Class1 -Filter "Name='$ClientName'" -ErrorAction STOP -computerName $SiteServer
    If ($Null -eq $ResourceIDQuery) {
      Write-Host "There is no such device like '$ClientName'"
    }
  }
  Catch {     
    Write-Host "Failed to query Resource ID"
  }
  Try {
    $ReturnCode = Invoke-WmiMethod -Namespace "root\sms\site_$SiteCode" -Class $Class2 -Name $Method -ArgumentList @($ResourceIDQuery.ResourceID, $AffinityType, 1, $Username) -ComputerName $SiteServer -ErrorAction STOP
    If ($ReturnCode.ReturnValue -eq 0) {
      Write-Host " - User Device Affinity created successfully" -ForegroundColor GREEN
    }
  }
  Catch {
    Write-Host " - Failed to create User Device Affinity" -ForegroundColor RED
  }
}
