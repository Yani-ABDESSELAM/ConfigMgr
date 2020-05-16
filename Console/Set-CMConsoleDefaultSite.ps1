return 0

# HKEY_CURRENT_USER\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1
# ServerName = CM01.DOMAIN.TLD
# SiteCode = XYX

$CMSiteServer = Get-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\DP\'
$CMSiteCode = Get-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\'

Set-ItemProperty -LiteralPath HKCU:\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1\ -Name 'ServerName' -Value $CMSiteServer.ManagementPoints -ErrorAction SilentlyContinue -Verbose

Set-ItemProperty -LiteralPath HKCU:\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1\ -Name 'SiteCode' -Value $CMSiteCode.AssignedSiteCode -ErrorAction SilentlyContinue -Verbose
