<#
.DESCRIPTION
  Uses the Configuration Manager module to add device(s) to collection(s)

.PARAMETER MultiAdd
  Use this when adding multiple devices.  Device names must be saved in a text file.

.PARAMETER CollectionName
  Use this when specifying the Collection Name. If parameter is not specific, you will be prompted with a list of collections from your environment to pick.

.PARAMETER Computer
  Use this when sepcifying a single device to add. If paramater is not specific, you will be prompted to enter the Computer Name.

.PARAMETER FilePath
  Specify the file path of the text file with device names. If not specified, you will be prompoted to browse and select the text file.

.NOTES

  This script requires the Configuration Manager Module!

.EXAMPLE
  Add-DeviceToCollection.ps1 -CollectionName 'OSD - Windows 10 Version 1909 Deployment' -Computer SEA-CAMERONK01

.EXAMPLE
  Add-DeviceToCollection.ps1 -MultiAdd Yes

.EXAMPLE
  Add-DeviceToCollection.ps1 -FilePath C:\Temp\Devices.txt
#>

[CmdletBinding()]

Param (
  [ValidateSet ('Yes', 'No')][string]$MultiAdd,
  [string]$CollectionName,
  [string]$Computer,
  [string]$FilePath
)

# Required for SCCM Script
Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
$smsClient = New-Object -ComObject Microsoft.SMS.Client -Strict
$siteCode = $smsclient.GetAssignedSite() + ":"
Set-Location $sitecode
# End Import

# Gather collection information
If ($CollectionName -eq '') {
  Write-Host 'Querying collections. Times may vary based on total number of collections.' -ForegroundColor Cyan -BackgroundColor Black
  $CollectionName = (Get-CMDeviceCollection | Select-Object Name | Sort-Object Name | Out-GridView -PassThru -Title 'Select collection:').Name
}
While (!(Get-CMDeviceCollection -Name $CollectionName)) { $CollectionName = Read-Host -Prompt "Incorrect Collection Name! Please Enter Device Collection Name" }

$CollectionId = (Get-CMDeviceCollection -Name $CollectionName).CollectionId
$CollectionMembers = (Get-CMCollectionMember -CollectionName $CollectionName).Name
[int]$Count = 0

Function Add-CMDeviceToCollection {
  If ($CollectionMembers -match $Computer) {
    Write-Host "$Computer is already a memeber of $CollectionName" -ForegroundColor White
  }
  Else {
    Try {
      $ComputerResourceId = (Get-CMDevice -Name $Computer).ResourceId
      Write-Host "Adding $Computer to" $CollectionName -ForegroundColor Cyan -BackgroundColor Black
      Add-CMDeviceCollectionDirectMembershipRule -CollectionId $CollectionId -ResourceId $ComputerResourceId
      Write-Host "Added $Computer to $CollectionName" -ForegroundColor Green -BackgroundColor Black
      $Count++
    }
    Catch {
      Write-Host "Unable to add" $Computer "to" $CollectionName -ForegroundColor Red -BackgroundColor Black
    }
  }
  Return $count
}

If ($MultiAdd -eq 'Yes' -or $FilePath -ne '') {

  If ($FilePath -eq '') {
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    $openFile = New-Object System.Windows.Forms.OpenFileDialog
    $openFile.Filter = "Txt Files (*.txt)|*.txt|All files (*.*)|*.*"

    Write-Host "Select file with device names" -ForegroundColor Cyan -BackgroundColor Black
    Start-Sleep -Seconds 3

    If ($openFile.ShowDialog() -eq "OK") {
      $ComputerList = Get-Content $openFile.FileName
    }
    Else { Exit }

    ($Results = Foreach ($computer in $ComputerList) { Add-CMDeviceToCollection }) | ForEach-Object { $Count += $_ }

    Write-Host "Successfully added device $Count to $CollectionName" -ForegroundColor Green -BackgroundColor Black
  }
  Else {
    $ComputerList = Get-content $FilePath
    ($Results = Foreach ($computer in $ComputerList) { Add-CMDeviceToCollection }) | ForEach-Object { $Count += $_ }
    Write-Host "Successfully added device $Count to $CollectionName" -ForegroundColor Green -BackgroundColor Black
  }
}
Else {
  If ($Computer -eq '') {
    $Computer = Read-Host -Prompt "Enter Device Name "
  }
  While (!(Get-CMDevice -Name $Computer)) { $Computer = Read-Host -Prompt "Incorrect device name! Please Enter Device Name" }
  Add-CMDeviceToCollection
}
Set-Location $env:SystemRoot
