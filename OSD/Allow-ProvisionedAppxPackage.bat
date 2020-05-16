: Need to modify the Registry to allow installation for All Users during OSD
REG LOAD HKLM\AppxProvisionTEMP C:\Windows\system32\config\SOFTWARE
REG ADD HKLM\SOFTWARE\Policies\Microsoft\Windows\Appx /t REG_DWORD /f /v "AllowAllTrustedApps" /d 1
REG UNLOAD HKLM\AppxProvisionTEMP
