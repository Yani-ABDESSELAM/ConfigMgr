Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Loads the powershell modules needed for the script to work
# You must have a compatable SCCM Admin consol for you site installed
Set-Location 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin'
Import-Module .\ConfigurationManager.psd1 -verbose:$false

# GUI Configuration
$form = New-Object System.Windows.Forms.Form 
$form.Text = "Enter Site Code"
$form.Size = New-Object System.Drawing.Size(250, 225) 
$form.StartPosition = "CenterScreen"

$OKButton = New-Object System.Windows.Forms.Button
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(125, 120)
$CancelButton.Size = New-Object System.Drawing.Size(75, 23)
$OKButton.Location = New-Object System.Drawing.Point(25, 120)
$OKButton.Size = New-Object System.Drawing.Size(75, 23)
$OKButton.Text = "OK"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20) 
$label.Size = New-Object System.Drawing.Size(280, 20) 
$label.Text = "Please enter the Site Code:"
$form.Controls.Add($label)

$textBox2 = New-Object System.Windows.Forms.TextBox 
$textBox2.Location = New-Object System.Drawing.Point(10, 50) 
$textBox2.Size = New-Object System.Drawing.Size(50, 20) 
$form.Controls.Add($textBox2) 

$form.Topmost = $True

[VOID] $form.Add_Shown
$result = $form.ShowDialog()
If ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
  Exit
}

# Sets the 3-Letter Configuration Manager Site for the Set-Location command!
$site = $textBox2.Text + ":"
Set-Location $site

# Begin GUI
$form = New-Object System.Windows.Forms.Form 
$form.Text = "Add Device to Collection"
$form.Size = New-Object System.Drawing.Size(400, 200) 
$form.StartPosition = "CenterScreen"

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75, 120)
$OKButton.Size = New-Object System.Drawing.Size(75, 23)
$OKButton.Text = "OK"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(225, 120)
$CancelButton.Size = New-Object System.Drawing.Size(75, 23)
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20) 
$label.Size = New-Object System.Drawing.Size(280, 20) 
$label.Text = "Please enter the Collection Name:"
$form.Controls.Add($label) 

$objCollection = New-Object System.Windows.Forms.ComboBox
$objCollection.Location = New-Object System.Drawing.Point(10, 40)
$objCollection.Size = New-Object System.Drawing.Size(305, 20)
$objCollection.DropDownStyle = "DropDownList"
$handler_TSTypeBox_SelectedIndexChanged = {
  If (($objCollection.Text) -and ($ComputerNameBox.Text)) {
    $OKButton.Enabled = 1
  }
  Else {
    $OKButton.Enabled = 0
  }
}
Foreach ($item in (Get-CMCollection).name) {
  $objCollection.Items.Add($item) | Out-Null
}
$objCollection.add_SelectedIndexChanged($handler_objCollectionBox_SelectedIndexChanged)
$form.Controls.Add($objCollection)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 61) 
$label.Size = New-Object System.Drawing.Size(280, 20) 
$label.Text = "Please enter the Computer Name:"
$form.Controls.Add($label) 

$textBox1 = New-Object System.Windows.Forms.TextBox 
$textBox1.Location = New-Object System.Drawing.Point(10, 80) 
$textBox1.Size = New-Object System.Drawing.Size(260, 20) 
$form.Controls.Add($textBox1) 

$form.Topmost = $True

[VOID] $form.Add_Shown
$result = $form.ShowDialog()

If ($result -eq [System.Windows.Forms.DialogResult]::OK) {
  $Coll = $objCollection.Text
  $Comp = $textBox1.Text
  #Finds the computers ResourceID to be used the add device command
  $PCID = $(get-cmdevice -Name $Comp).ResourceID
  #Adds the computer to the collection
  Add-CMDeviceCollectionDirectMembershipRule -CollectionName "$Coll" -ResourceID $PCID
}
