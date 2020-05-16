<#
.DESCRIPTION
Gets department attribute from user and creates user collections based on that adds all the memebers of that department to the user collection. 
This script is ment to run on the Primary Site. 
#>

$SiteCodeObjs = Get-WmiObject -Namespace "root\SMS" -Class SMS_ProviderLocation -ComputerName $env:COMPUTERNAME -ErrorAction Stop

ForEach ($SiteCodeObj In $SiteCodeObjs) {
  If ($SiteCodeObj.ProviderForLocalSite -eq $true) {
    $SiteCode = $SiteCodeObj.SiteCode
  }

  $SitePath = $SiteCode + ":"
  Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0, $Env:SMS_ADMIN_UI_PATH.Length - 5) + '\ConfigurationManager.psd1')

}

$LimitingCollections = "All Users"
$Users = Get-WmiObject -Namespace "root\SMS\Site_$($Sitecode)" -Class SMS_R_User -ComputerName $env:COMPUTERNAME -ErrorAction Stop
$Groups = $Users.department | Sort-Object | Get-Unique 
Set-location $SitePath
$Sched = New-CMSchedule -DayOfWeek Sunday

ForEach ($Group in $Groups) {
  If (Get-CMUserCollection -name $Group) { }
  Else {
    $Query = "select SMS_R_USER.ResourceID,SMS_R_USER.ResourceType,SMS_R_USER.Name,SMS_R_USER.UniqueUserName,SMS_R_USER.WindowsNTDomain from SMS_R_User where SMS_R_User.department = '$($Group)'"
    New-CMUserCollection -Name $Group -LimitingCollectionName $LimitingCollections -RefreshSchedule $Sched
    Start-Sleep -Seconds 1
    Add-CMUserCollectionQueryMembershipRule -CollectionName $Group -QueryExpression $Query -RuleName $Group
  }
}
