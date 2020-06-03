# Encryption Oracle Remediation
# _Remediation.ps1

# Author: Cameron Kollwitz
# Date: Jun 02, 2020

# Group Policy Equivilant: Computer Configuration -> Administrative Template -> System -> Credentials Delegation -> Encryption Oracle Remediation

# Create the Registry Key if it does not already exist
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP" -force -ea SilentlyContinue };

# A DWORD32 Value of '2' (Hexidecimal) configures the setting to 'Vulnerable'
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters" -force -ea SilentlyContinue };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters' -Name 'AllowEncryptionOracle' -Value 2 -PropertyType DWord -Force -ea SilentlyContinue;
