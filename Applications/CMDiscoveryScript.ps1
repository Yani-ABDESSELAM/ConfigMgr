# _CMDiscoveryScript.ps1
# Use this script as a templace for application discovery when using the "Script" method for detection.

# Define strings and their location. Also include the filename.
$String1 = ""
$String1Location = ""

$String2 = ""
$String2Location = ""

$String3 = ""
$String3Location = ""

# Detect presence of String1 in String1 Location
Try {
  $String1Exists = Get-Content $String1Location -ErrorAction Stop
}
Catch {
}

# Detect presence of String2 in String2 Location
Try {
  $String2Exists = Get-Content $String2Location -ErrorAction Stop
}
Catch {
}

# Detect presence of String3 in String3 Location
Try {
  $String3Exists = Get-Content $String3Location -ErrorAction Stop
}
Catch {
}

If (($String1Exists -match $String1) -and ($String2Exists -match $String2) -and ($String3Exists -match $String3)) {
  Write-Host "Installed"
}
Else {
}
