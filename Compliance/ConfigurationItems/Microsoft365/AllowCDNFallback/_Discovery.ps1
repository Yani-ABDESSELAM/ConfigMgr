# Allow CDN Fallback for Microsoft Office Updates
# ConfigMgr\Compliance\ConfigurationItems\Microsoft365\AllowCDNFallback\_Discovery.ps1

# Author:       Cameron Kollwitz
# Date:         12/20/2019
# Description:  Evaluate if the device can receive Microsoft Office Updates from the Microsoft CDN as a fallback if the device is not on the local network.

# Note:         This can also be set in the installation XML file for the Office Deployment Tool.

Try {
  If ((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' -Name 'AllowCdnFallback' -ea SilentlyContinue) -eq "True") { } Else { Return $false };
}
Catch { Return $false }
Return $true
