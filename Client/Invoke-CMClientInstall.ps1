# Configuration Manager Variables
$CMMP = 'sea-cm01.mckinstry.com'
$CMSiteCode = 'SEA'

$ErrorActionPreference = "SilentlyContinue" 

## Phase One: Correct the permissions for the CM Client

# Fix DCOM Permissions for CM Client
Try {
  # Default Launch Permissions
  $Reg = [WMIClass]"root\default:StdRegProv"
  $newDCOMSDDL = "O:BAG:BAD:(A;;CCDCLCSWRP;;;SY)(A;;CCDCLCSWRP;;;BA)(A;;CCDCLCSWRP;;;IU)"
  $DCOMbinarySD = $converter.SDDLToBinarySD($newDCOMSDDL)
  $Reg.SetBinaryValue(2147483650,"SOFTWARE\Microsoft\Ole","DefaultLaunchPermission", $DCOMbinarySD.binarySD)

  # Machine Access Restrictions
  $Reg = [WMIClass]"root\default:StdRegProv"
  $newDCOMSDDL = "O:BAG:BAD:(A;;CCDCLC;;;WD)(A;;CCDCLC;;;LU)(A;;CCDCLC;;;S-1-5-32-562)(A;;CCDCLC;;;AN)"
  $DCOMbinarySD = $converter.SDDLToBinarySD($newDCOMSDDL)
  $Reg.SetBinaryValue(2147483650,"SOFTWARE\Microsoft\Ole","MachineAccessRestriction", $DCOMbinarySD.binarySD)

  # Machine Launch Restrictions
  $Reg = [WMIClass]"root\default:StdRegProv"
  $newDCOMSDDL = "O:BAG:BAD:(A;;CCDCSW;;;WD)(A;;CCDCLCSWRP;;;BA)(A;;CCDCLCSWRP;;;LU)(A;;CCDCLCSWRP;;;S-1-5-32-562)"
  $DCOMbinarySD = $converter.SDDLToBinarySD($newDCOMSDDL)
  $Reg.SetBinaryValue(2147483650,"SOFTWARE\Microsoft\Ole","MachineLaunchRestriction", $DCOMbinarySD.binarySD)
}
Catch { Out-Null }

# Remove Old CM Client Certificates
Try {
  Remove-Item -path HKLM:\SOFTWARE\Microsoft\SystemCertificates\SMS\* -Recurse
}
Catch { Out-Null }

# Re-Register CM Client DLLs
Try {
  regsvr32.exe /s "C:\WINDOWS\system32\actxprxy.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\atl.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\Bitsprx2.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\Bitsprx3.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\browseui.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\cryptdlg.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\dssenh.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\gpkcsp.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\initpki.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\jscript.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\mshtml.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\msi.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\mssip32.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\msxml3.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\msxml3r.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\msxml6.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\msxml6r.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\muweb.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\ole32.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\oleaut32.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\Qmgr.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\Qmgrprxy.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\rsaenh.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\sccbase.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\scrrun.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\shdocvw.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\shell32.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\slbcsp.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\softpub.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\urlmon.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\userenv.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\vbscript.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\Winhttp.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\wintrust.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\wuapi.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\wuaueng.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\wuaueng1.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\wucltui.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\wucltux.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\wups.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\wups2.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\wuweb.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\wuwebv.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\wbem\wmisvc.dll"
  regsvr32.exe /s "C:\WINDOWS\system32\Xpob2res.dll"
}
Catch { Out-Null }

## Phase Two: Remove old cache and reinstall CM Client

Try { 
  # Get CCMCache path for cleanup a bit later
  Try { 
    $ccmcache = ([wmi]"ROOT\ccm\SoftMgmtAgent:CacheConfig.ConfigKey='Cache'").Location 
  }
  Catch { Out-Null } 

  # Grab ccmsetup.exe from the Management Point
  $webclient = New-Object System.Net.WebClient 
  $url = "http://$($CMMP)/CCM_Client/ccmsetup.exe" 
  $file = "c:\windows\temp\ccmsetup.exe" 
  $webclient.DownloadFile($url, $file) 

  # Stop the old `CcmExec` Service if it is still running 
  Stop-Service 'ccmexec' -ErrorAction SilentlyContinue 

  # Cleanup CCMCache of old items
  If ($null -ne $ccmcache) { 
    Try { 
      Get-ChildItem $ccmcache '*' -directory | ForEach-Object { [io.directory]::delete($_.fullname, $true) } -ErrorAction SilentlyContinue 
    }
    Catch { Out-Null } 
  } 

  # Cleanup Execution History -- Disabled as we don't need this anymore
  #Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\SMS\Mobile Client\*' -Recurse -ErrorAction SilentlyContinue 
  #Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\*' -Recurse -ErrorAction SilentlyContinue 

  # Kill existing instances of `ccmsetup.exe` that might have hung
  $ccm = (Get-Process 'ccmsetup' -ErrorAction SilentlyContinue) 
  if ($null -ne $ccm) { 
    $ccm.kill(); 
  } 

  # Install the CM Client on the device
  $proc = Start-Process -FilePath 'c:\windows\temp\ccmsetup.exe' -PassThru -Wait -ArgumentList "/UsePKICert /NoCRLCheck /MP:$($CMMP) DNSSUFFIX=$($CMDomain) CCMHTTPSSTATE=31 SMSCACHESIZE=$($CMCacheSize) /source:http://$($CMMP)/CCM_Client CCMHTTPPORT=80 CCMHTTPSPORT=443 RESETKEYINFORMATION=TRUE SMSSITECODE=$($CMSiteCode) SMSSLP=$($CMMP) FSP=$($CMMP)"
  Start-Sleep 5
  Write-Host "ConfigMgr Client Installation has Started..." 
  Write-Host "Please allow 15-30 minutes before opening Software Center!"
} 

Catch { 
  "Yike, an Error occured..." 
  $error[0] 
}
