# Configuration Item: Font - Remediation Script
# _Remediation.ps1

# Author: Cameron Kollwitz
# Date: Jun 08, 2020

# Group Policy Equivilant: Adding files directly to C:\Windows\Fonts\

$FontBase64 = @"
INPUT_YOUR_BASE64_STRING_HERE
"@

# Decode the font's Base64
$FontContent = [System.Convert]::FromBase64String($FontBase64)

# Place the decoded font into the Public Pictures directory so all accounts on the device can access it.
Set-Content -Path "$ENV:SystemRoot\Fonts\STAGSANS-LIGHT.OTF" -Value $FontContent -Encoding Byte

# Create the Registry value to install the font for all users
# Best way to get the string for 'Name' is to install the font on the device and manually check the Registry for the name
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' -Name 'FONT-NAME-HERE' -PropertyType String -Value FONT-FILE-NAME-HERE.otf
