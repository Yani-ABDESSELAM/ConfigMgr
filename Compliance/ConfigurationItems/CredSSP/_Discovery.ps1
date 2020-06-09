# Encryption Oracle Remediation
# _Discovery.ps1

# Author: Cameron Kollwitz
# Date: Jun 06, 2020

# Group Policy Equivilant: Computer Configuration -> Administrative Template -> System -> Credentials Delegation -> Encryption Oracle Remediation

try {
	if(-NOT (Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP")){ return $false };
	if(-NOT (Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters")){ return $false };
	if((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters' -Name 'AllowEncryptionOracle' -ea SilentlyContinue) -eq 2) {  } else { return $false };
}
catch { return $false }
return $true
