# Script Get-TSPassword.ps1
# ***** Disclaimer *****
# This file is provided "AS IS" with no warranties, confers no 
# rights, and is not supported by the authors or Microsoft 
# Corporation. Its use is subject to the terms specified in the 
# Terms of Use (http://www.microsoft.com/info/cpyright.mspx).
#
# HOW TO USE
# 1. Create a Step "Sets the Task Sequence Variable" in which you set the Task Sequence Variable "TSPassword". The Value of this Variable will be used to check against the Input in the Get-TSPassword Script.
#
# 2. Command line to run:
#
#       ServiceUI.exe -process:TSProgressUI.exe %SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File Get-TSPassword.ps1

# -----------------------------------------------------------------------------------
# Function Section
# -----------------------------------------------------------------------------------
Function Set-OKButton {
  <#
  .SYNOPSIS
      Compares the entered Password with the TSPassword 
  .DESCRIPTION
      Function to compare the Variable "TSPassword" with the entered Password
  #>
  #If ($tsenv.Value("TSPassword") -eq $MaskedTextBox) {
  # Apparently the If statement will not work unless written as:
  If ($tsenv.Value("TSPassword") -eq ($MaskedTextBox).text) {
    $tsenv.Value("TSPasswordChecked") = $True 
  }
}


# -----------------------------------------------------------------------------------
# Worker Section
# ----------------------------------------------------------------------------------- 
# Construct TSEnv object
Try {
  $TSEnv = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
}
Catch [System.Exception] {
  Write-Warning -Message "Unable to construct Microsoft.SMS.TSEnvironment object" ; exit 1
}

#GUI Creation
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Task Sequence Password"
$objForm.Size = New-Object System.Drawing.Size(300, 200) 
$objForm.StartPosition = "CenterScreen"
$objForm.KeyPreview = $True

$objForm.Add_KeyDown( {
    If ($_.KeyCode -eq "Enter") {
      Set-OKButton; $objForm.Close()
    }
  })
$objForm.Add_KeyDown( {
    If ($_.KeyCode -eq "Escape") {
      $objForm.Close()
    }
  })

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(75, 120)
$OKButton.Size = New-Object System.Drawing.Size(75, 23)
$OKButton.Text = "OK"
$OKButton.Add_Click( {
    Set-OKButton; $objForm.Close()
  })
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(150, 120)
$CancelButton.Size = New-Object System.Drawing.Size(75, 23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click( {
    $objForm.Close()
  })
$objForm.Controls.Add($CancelButton)

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10, 20) 
$objLabel.Size = New-Object System.Drawing.Size(280, 20) 
$objLabel.Text = "Please enter the password for this Task Sequence:"
$objForm.Controls.Add($objLabel)

$MaskedTextBox = New-Object System.Windows.Forms.MaskedTextBox
$MaskedTextBox.PasswordChar = '*'
$MaskedTextBox.Location = New-Object System.Drawing.Size(10, 40) 
$MaskedTextBox.Size = New-Object System.Drawing.Size(260, 20) 
$objForm.Controls.Add($MaskedTextBox) 
$objForm.Topmost = $True
$objForm.Add_Shown( { $objForm.Activate() })

[void] $objForm.ShowDialog()
