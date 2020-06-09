# Allow CDN Fallback for Microsoft Office Updates
# ConfigMgr\Compliance\ConfigurationItems\Microsoft365\AllowCDNFallback\_Remediation.ps1

# Author:       Cameron Kollwitz
# Date:         12/20/2019
# Description:  Enable the device to receive Microsoft Office Updates from the Microsoft CDN as a fallback if the device is not on the local network.

# Note:         This can also be set in the installation XML file for the Office Deployment Tool.

# Verify that the key exists. It should, but let's be sure...
If ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration") -ne $true) { New-Item "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Force -ea SilentlyContinue };

# Create the new Registry Value that enables the setting for the device.
New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Name "AllowCdnFallback" -Value "True" -PropertyType String -Force -ea SilentlyContinue;
