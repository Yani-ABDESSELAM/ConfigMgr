# Configuration Item: Font - Detection Script
# _Discovery.ps1

# Author: Cameron Kollwitz
# Date: Jun 08, 2020

# Group Policy Equivilant: Adding files directly to C:\Windows\Fonts\

# Load the function we need to evaluate the Registry correctly...
Function Test-RegistryKeyValue {
  <#
    .SYNOPSIS
    Tests if a registry value exists.
    
    .DESCRIPTION
    The usual ways for checking if a registry value exists don't handle when a value simply has an empty or null value.  This function actually checks if a key has a value with a given name.
  
    .EXAMPLE
    Test-RegistryKeyValue -Path 'HKLM:\SOFTWARE\Microsoft\Test' -Name 'Title'
  
    Returns 'True' if 'HKLM:\SOFTWARE\Microsoft\Test' contains a value named 'Title' and 'False' otherwise.
    #>
    
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)][string]
    # The path to the registry key where the value should be set.  Will be created if it doesn't exist.
    $Path,
    [Parameter(Mandatory = $true)][string]
    # The name of the value being set.
    $Name
  )
  
  if ( -not (Test-Path -Path $Path -PathType Container) ) {
    return $false
  }
  
  $properties = Get-ItemProperty -Path $Path
  
  if ( -not $properties ) {
    return $false
  }
  
  $member = Get-Member -InputObject $properties -Name $Name
  if ( $member ) {
    return $true
  }
  else {
    return $false
  }
  
}
  
# Check for the Stag Sans Light font in the device's registry. This key only appears when the font has been installed correctly.
Test-RegistryKeyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts\' -Name 'Stag Sans Light (OpenType)'
#Test-RegistryKeyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts\' -Name 'StagSans-Light (TrueType)'
