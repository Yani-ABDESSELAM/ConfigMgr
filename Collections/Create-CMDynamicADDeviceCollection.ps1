################################################################################
#
#   Author: Jack O'Connor
#   Description: Create ConfigMgr Device Collections from Active Directory Organisational Units and Computers
#   Website: https://github.com/JackOconnor21
#
#   Params: OUSearchBase, LimitingCollection, MembershipRule, CollectionFolder
#   Example: .\Create-CollectionsFromOUs.ps1 -OUSearchBase "OU=Workstations,OU=Internal IT,OU=JACKO,DC=JACKO,DC=LOCAL" -LimitingCollection "All Systems" -ExcludedOUS "Admin Accounts, Users" -MembershipRule "Query" -CollectionFolder "Test" -Tag "EUR"
#   Logging Keys:
#      - Green: Success, Red: Failure, Cyan: General (Info)
#
#   Docs:
#    OUSearchBase:
#      The children of the OU passed as the OUSearchBase will have device collections created with their names.
#    LimitingCollection:
#      The LimitingCollection is self-explanitory, it is simply the limiting collection of the device collections that are being created.
#    ExcludedOUs:
#      Here we can define any OUs that we wish to explicitly exclude and not create a device collection for. (typically this is OUs which contain accounts)
#    MembershipRule:
#      The MemberShipRule can be either Query or Direct. If 'Query' then all devices from the OUs will be pulled into the device collection, now and in the future (due to the query on the collection).
#      If the MembershipRule is Direct then all members in the OUs will be pulled in one time only, but not any future devices.
#    CollectionFolder:
#      The value you pass here as a param will be the folder your new device collections will be added to. E.G. "Operational"
#    Tag:
#      Optionally tag the device collection with a name. This will appear as such 'OU Based | $Tag | CollectionName' (for example a site code could be used if you have many sites)
#   
################################################################################
Param(
  [Parameter(Mandatory = $true)][String]$OUSearchBase,
  [Parameter(Mandatory = $true)][String]$LimitingCollection,
  [String]$ExcludedOUs,
  [Parameter(Mandatory = $true)][String]$MembershipRule,
  [Parameter(Mandatory = $true)][String]$CollectionFolder,
  [String]$Tag
)
 
# Check for elevation
#Write-Host "Checking for elevation"
#If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
#      [Security.Principal.WindowsBuiltInRole] "Administrator")) {
#  Write-Warning "Please run from elevated PowerShell prompt!"
#  Write-Warning "Aborting script..."
#  Break
#}
 
$Path = Get-Location
 
# Import the ConfigurationManager.psd1 module 
if ($null -eq (Get-Module ConfigurationManager)) {
  Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
}
 
$SiteCode = (Get-PSDrive -PSProvider CMSITE).Name
 
Import-Module ActiveDirectory
Write-Host "Imported the 'ActiveDirectory' module" -ForegroundColor Cyan
 
Set-Location "$SiteCode`:"
 
# Create a schedule to run every 4 hours.
$Schedule = New-CMSchedule -RecurInterval Hours -RecurCount 4
 
# Get all OUs that are one level below the given OU as the search base
$OUs = Get-ADOrganizationalUnit -LDAPFilter "(name=*)" -SearchScope OneLevel -SearchBase $OUSearchBase
 
# Convert the string of comma-separated excluded OUs to an array
If ($ExcludedOUs) {
  $ExcOUArr = $ExcludedOUs.Split(",").Trim()
}
 
If ($Tag) { 
  $Tag = " $Tag |" 
}
Else { 
  $Tag = "" 
}
 
# Loop each of the OUs that we have found above
Foreach ($OU in $OUs) {
 
  # Skip doing anything with OUs and Computers that have been excluded
  if ($ExcOUArr -Contains $OU.Name) { 
    Write-Host "Excluding '$($OU.Name)' from being processed." -ForegroundColor Gray
    continue 
  }
 
  Write-Host "Looping over the '$($OU.Name)' OU" -ForegroundColor Cyan
 
  # Create a new device collection within SCCM with the given parameters
  try {
    $currCollection = New-CMDeviceCollection -Name "Dynamic OU Collection |$Tag $($OU.Name)" -LimitingCollectionName $LimitingCollection -RefreshSchedule $Schedule -RefreshType Periodic
    Write-Host "New ConfigMgr Device Collection created with the name '$($OU.Name)'" -ForegroundColor Green
 
    # Allows for the passing of a collection folder which is the folder your created device collections will be moved into.
    $CollectionPath = $SiteCode + ":\DeviceCollection\$CollectionFolder"
 
    # Move the device collection into the chosen collection folder.
    Move-CMObject -FolderPath $CollectionPath -InputObject (Get-CMDeviceCollection -Name $currCollection.Name)
 
    # Set is error to false to indicate no error has occurred.
    $isError = 0
  }
  catch {
    Write-Host "Error creating Device Collection '$($OU.Name)' - This Device Collection may already exist. Any new found devices will still be added." -ForegroundColor Red
    $isError = 1
  }
 
  # If the membership rule is query and there has not been an error.
  If ($MembershipRule -eq "Query" -AND !$isError) {
 
    # Convert the OU Distinguished name to the canonical name of the OU.
    $CanonicalOUName = Get-CanonicalName($OU.DistinguishedName)
 
    # The device collection query will differ based on which members are to be added.
    $Query = 'SELECT *  FROM  SMS_R_System WHERE SMS_R_System.SystemOUName = "' + $($CanonicalOUName) + '"'
 
    # Add the query membership rule to the Device Collection
    Add-CMDeviceCollectionQueryMembershipRule -CollectionId $currCollection.CollectionId -QueryExpression $Query -RuleName $OU.Name
 
  }
  ElseIf ($MembershipRule -eq "Direct") {
 
    # Get all computers that exist beneath the current OU at any level
    $ADComps = Get-ADComputer -LDAPFilter "(name=*)" -SearchBase "OU=$($OU.Name),$OUSearchBase" -SearchScope Subtree
 
    # Loop each of the computers beneath the current OU within AD
    Foreach ($Comp in $ADComps) {
      Write-Host "Looping over all AD computer '$($Comp.Name)' within the $($OU.Name) OU" -ForegroundColor Cyan
 
      # Get the resource ID of the current computer
      $ResourceID = $(Get-CMDevice -Name $Comp.Name).ResourceID 
 
      # Add the current computer device into the current device collection based on the resource ID of the machine
      try {
        Add-CMDeviceCollectionDirectMembershipRule -CollectionName "OU Based |$Tag $($OU.Name)" -ResourceId $ResourceID
        Write-Host "AD computer '$($Comp.Name)' added to the '$($OU.Name)' ConfigMgr Device Collection" -ForegroundColor Green
      }
      catch {
        Write-Host "Error adding device '$($Comp.Name)' to collection '$($OU.Name)' - This device may already exist within the collection." -ForegroundColor Red
      }
    }
  }
}
 
Set-Location $Path
 
# Function by thepip3r @ https://gallery.technet.microsoft.com/scriptcenter/Get-CanonicalName-Convert-a2aa82e5
Function Get-CanonicalName ([string[]]$DistinguishedName) {    
  foreach ($dn in $DistinguishedName) {      
    $d = $dn.Split(',') ## Split the dn string up into it's constituent parts 
    $arr = (@(($d | Where-Object { $_ -notmatch 'DC=' }) | ForEach-Object { $_.Substring(3) }))  ## get parts excluding the parts relevant to the FQDN and trim off the dn syntax 
    [array]::Reverse($arr)  ## Flip the order of the array. 
 
    ## Create and return the string representation in canonical name format of the supplied DN 
    "{0}/{1}" -f (($d | Where-Object { $_ -match 'dc=' } | ForEach-Object { $_.Replace('DC=', '') }) -join '.'), ($arr -join '/') 
  } 
}
