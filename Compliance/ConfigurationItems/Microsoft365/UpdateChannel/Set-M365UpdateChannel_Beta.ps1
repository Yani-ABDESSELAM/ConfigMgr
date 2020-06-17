# Microsoft 365 Apps | Update Channel
# Beta Channel (Insiders Fast)

# Discovery
Try {
  If (-NOT (Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate")) { Return $false };
  If (-NOT (Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration")) { Return $false };
  If ((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate' -Name 'preventbinginstall' -ea SilentlyContinue) -eq 1) {  } Else { Return $false };
  If ((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate' -Name 'updatebranch' -ea SilentlyContinue) -eq 'InsiderFast') {  } Else { Return $false };
  If ((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate' -Name 'officemgmtcom' -ea SilentlyContinue) -eq 0) {  } Else { Return $false };
  If ((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate' -Name 'enableautomaticupdates' -ea SilentlyContinue) -eq 1) {  } Else { Return $false };
  If ((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' -Name 'CDNBaseUrl' -ea SilentlyContinue) -eq 'http://officecdn.microsoft.com/pr/5440fd1f-7ecb-4221-8110-145efaa6372f') {  } Else { Return $false };
  If ((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' -Name 'UpdatesEnabled' -ea SilentlyContinue) -eq 'True') {  } Else { Return $false };
  If ((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' -Name 'UpdateChannel' -ea SilentlyContinue) -eq 'http://officecdn.microsoft.com/pr/5440fd1f-7ecb-4221-8110-145efaa6372f') {  } Else { Return $false };
  If ((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' -Name 'AllowCdnFallback' -ea SilentlyContinue) -eq 'True') {  } Else { Return $false };
  If ((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' -Name 'OfficeMgmtCOM' -ea SilentlyContinue) -eq '0') {  } Else { Return $false };
  If ((Get-ItemPropertyValue -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' -Name 'UpdateUrl' -ea SilentlyContinue) -eq 'http://officecdn.microsoft.com/pr/5440FD1F-7ECB-4221-8110-145EFAA6372F') {  } Else { Return $false };
}
Catch { Return $false }
Return $true

# Remediation
If ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate") -ne $true) { New-Item "HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate" -Force -ea SilentlyContinue };
If ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration") -ne $true) { New-Item "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Force -ea SilentlyContinue };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate' -Name 'preventbinginstall' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate' -Name 'updatebranch' -Value 'InsiderFast' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate' -Name 'officemgmtcom' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate' -Name 'enableautomaticupdates' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' -Name 'CDNBaseUrl' -Value 'http://officecdn.microsoft.com/pr/5440fd1f-7ecb-4221-8110-145efaa6372f' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' -Name 'UpdatesEnabled' -Value 'True' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' -Name 'UpdateChannel' -Value 'http://officecdn.microsoft.com/pr/5440fd1f-7ecb-4221-8110-145efaa6372f' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' -Name 'AllowCdnFallback' -Value 'True' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' -Name 'OfficeMgmtCOM' -Value '0' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' -Name 'UpdateUrl' -Value 'http://officecdn.microsoft.com/pr/5440FD1F-7ECB-4221-8110-145EFAA6372F' -PropertyType String -Force -ea SilentlyContinue;
