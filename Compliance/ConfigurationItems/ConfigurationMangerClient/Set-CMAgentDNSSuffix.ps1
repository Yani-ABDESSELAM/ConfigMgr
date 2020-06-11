# Set DNS Suffix on Configuration Manager Client
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\CCM\LocationServices" -Name "DnsSuffix" -PropertyType String -Force -Value domain.tld
