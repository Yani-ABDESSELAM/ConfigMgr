#
# Press 'F5' to run this script. Running this script will load the ConfigurationManager
# module for Windows PowerShell and will connect to the site.
#

# Uncomment the line below if running in an environment where script signing is 
# required.
#Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Site Configuration
$SiteCode = (Read-Host -Prompt "Enter the CM Site Code") # Site code
$ProviderMachineName = (Read-Host -Prompt "Enter the CM Primary Site Address") # SMS Provider machine name

# Customizations
$initParams = @{ }
#$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
#$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

# Import the ConfigurationManager.psd1 module
If ( $null -eq (Get-Module ConfigurationManager) ) {
  Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}

# Import the actual function
Function Invoke-DPRedistributeContent { 
  [CMDletBinding()] 
  param ( 
    [Parameter(Mandatory = $True)] 
    [ValidateNotNullorEmpty()] 
    [String]$DistributionPoint, 
    [Parameter(Mandatory = $True)] 
    [ValidateNotNullorEmpty()] 
    [String]$SiteCode 
  ) 
  Process { 
    $query = 'SELECT * FROM SMS_PackageStatusDistPointsSummarizer WHERE State = 2 OR State = 3' 
    $Packages = Get-WmiObject -Namespace "root\SMS\Site_$($SiteCode)" -Query $query | Select-Object PackageID, @{N = 'DistributionPoint'; E = { $_.ServerNalPath.split('\')[2] } } 
    $FailedPackages = $Packages | Where-Object { $_.DistributionPoint -like "$DistributionPoint" } | Select-Object -ExpandProperty PackageID 
    foreach ($PackageID in $FailedPackages) { 
      $List = Get-WmiObject -Namespace "root\SMS\Site_$($SiteCode)" -Query "Select * From SMS_DistributionPoint WHERE PackageID='$PackageID' AND ServerNALPath like '%$DistributionPoint%'" 
      $List.RefreshNow = $True 
      $List.Put() 
    } 
  } 
}
