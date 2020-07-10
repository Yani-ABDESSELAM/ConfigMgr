Function Update-CMDeviceCollection { 
  <# 
    .Synopsis 
       Update SCCM Device Collection 
    .DESCRIPTION 
       Update SCCM Device Collection. Use the -Wait switch to wait for the update to complete. 
    .EXAMPLE 
       Update-CMDeviceCollection -DeviceCollectionName "All Workstations" 
    .EXAMPLE 
       Update-CMDeviceCollection -DeviceCollectionName "All Workstations" -Wait -Verbose 
    #> 

  [CmdletBinding()] 
  [OutputType([int])] 
  Param 
  ( 
    [Parameter(Mandatory = $true, 
      ValueFromPipelineByPropertyName = $true, 
      Position = 0)] 
    $DeviceCollectionName, 
    [Switch]$Wait 
  ) 

  Begin { 
    Write-Verbose "$DeviceCollectionName : Update Started" 
  } 
  Process { 
    $Collection = Get-CMDeviceCollection -Name $DeviceCollectionName 
    $null = Invoke-WmiMethod -Path "ROOT\SMS\Site_XXX:SMS_Collection.CollectionId='$($Collection.CollectionId)'"  -Name RequestRefresh  
  } 
  End { 
    if ($Wait) { 
      While ($(Get-CMDeviceCollection -Name $DeviceCollectionName | Select-Object -ExpandProperty CurrentStatus) -eq 5) { 
        Write-Verbose "$DeviceCollectionName : Updating..." 
        Start-Sleep -Seconds 5 
      } 
      Write-Verbose "$DeviceCollectionName : Update Complete!" 
    } 
  } 
} 


Function Verify-CCHEval {
  Param(

    [Parameter(Mandatory = $true)][string]$computername
  )    

  $EvalOK = 'Updating MDM_ConfigSetting.ClientHealthStatus with value 7'
  $Lastline = Get-Content "filesystem::\\$computername\C$\windows\ccm\logs\CcmEval.log" | Select-Object -SkipLast 1 | Select-Object -Last 1
  If ($lastline -match $EvalOK) {
    $true
  }
  Else {
    $false
  }
}

Set-Location hq1:
ipconfig /flushdns | Out-Null

$coll = "Currently Offline Windows 10 Clients" 
$i = 1
Update-CMDeviceCollection -DeviceCollectionName $coll -Wait -Verbose 
$Targets = Get-CMCollectionMember -CollectionName $coll | Sort-Object name
$Total = $Targets.Count

$results = @()
ForEach ($target in $targets) {
  $c = $target.name
  Write-Host "Pinging $c ($i/$Total)" -ForegroundColor White
  $i += 1
  If (Test-Connection $c -Quiet -Count 1) {
    Write-Host "`t$c is ONLINE.  Running CCM Evaluation" -ForegroundColor cyan
    $OnlineStatus = "Online"
    TRy {
      Invoke-Command -ComputerName $c -ScriptBlock { Start-Process "c:\windows\ccm\ccmeval.exe" -Wait }  -ea Stop
      $CCMEValCheck = Verify-CCHEval -computername $c
      If ( $CCMEValCheck -eq $false) {
        Write-Host "`tCCM Client has issues... Reinstalling client" -ForegroundColor yellow
        $ClientStatus = "Error"
        Invoke-Command -ComputerName $c -ScriptBlock {
          Start-Process c:\windows\ccmsetup\ccmsetup.exe -ArgumentList '/mp:contoso.com /forceinstall SMSSITECODE=XXX /BITSPriority:FOREGROUND' -Wait
        }

      }
      Else {
        Write-Host "`tCCM Client is OK" -ForegroundColor green

        $ClientStatus = "OK"
      }
    }
    Catch {
      Write-Host "`tFailed to run CCMEVAL on $c" -ForegroundColor red
      $ClientStatus = "Unknown (Could not run CCMEval)"
    }
  }
  Else {
    $OnlineStatus = "Offline"
    $ClientStatus = "Offline"

  }
  $results += [pscustomobject] @{
    Computer    = $c
    Status      = $OnlineStatus
    ClientState = $ClientStatus 

  }
}
$results | Where-Object ClientState -EQ "Error"