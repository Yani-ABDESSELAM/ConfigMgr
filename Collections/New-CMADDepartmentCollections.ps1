#Requires -Modules ActiveDirectory

# This Scripts requires that the department AD Attribute has been added in 'Active Directory User Discovery'
# Line 33 creates a list of unique Departmentnames, edit as needed
# Line 37 grabs what in my case is the Department Number which is used for naming the collection, and used in the query
# Line 44 moves the collection to a folder - Folder needs to exist beforehand

# Site configuration
$SiteCode = (Read-Host -Prompt "Enter the Site Code") # Site code
$ProviderMachineName = (Read-Host -Prompt "Enter the SMS Provider Host") # SMS Provider machine name

# Script Options
$initParams = @{ }
$initParams.Add("Verbose", $true) # Verbose logging.
$initParams.Add("ErrorAction", "Stop") # Stop the script on any error.

# Do not change anything below this line

# Import the ConfigurationManager.psd1 module
if ($null -eq (Get-Module ConfigurationManager)) {
  Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams
}

# Connect to the site's drive if it is not already present
if ($null -eq (Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue)) {
  New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" @initParams
$Departments = Get-ADUser -filter "Department -like '260*'" -Properties Department | Select-Object -ExpandProperty Department -Unique | Sort-Object
$Schedule1 = New-CMSchedule -Start "01/01/2019 7:00 AM" -RecurInterval Days -RecurCount 1

Foreach ($Department in $Departments) {
  $DepartmentNumber = $Department.Substring(0, 7)

  if ($null -eq (Get-CMCollection -Name $DepartmentNumber)) {
    Write-Host "$DepartmentNumber does not exist"
        
    $NewCollection = New-CMCollection -LimitingCollectionId SMS00002 -Name "$DepartmentNumber" -RefreshSchedule $Schedule1 -RefreshType Periodic -CollectionType User 
    Move-CMObject -FolderPath '.\UserCollection\Department Collections' -InputObject $NewCollection
    Add-CMUserCollectionQueryMembershipRule -CollectionName $DepartmentNumber -RuleName "Department$DepartmentNumber" -QueryExpression "select SMS_R_USER.ResourceID,SMS_R_USER.ResourceType,SMS_R_USER.Name,SMS_R_USER.UniqueUserName,SMS_R_USER.WindowsNTDomain from SMS_R_User where SMS_R_User.department like '$DepartmentNumber%'"

  }
}
