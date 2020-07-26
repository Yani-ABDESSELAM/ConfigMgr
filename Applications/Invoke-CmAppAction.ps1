Function Invoke-CmAppAction {
  param(
    [string]$ComputerName = '.',
    [ValidateSet('Install', 'Uninstall')][string]$Action = 'Install'
  )

  [hashtable]$params = @{
    ComputerName = $ComputerName
    Namespace    = 'root\CCM\ClientSDK'
    Class        = 'CCM_Application'
  }

  [array]$apps = @(gwmi @params -Filter "ApplicabilityState = 'Applicable'" -ErrorAction Stop)
	
  if ($apps.Length -eq 0) {
    throw 'No apps available.'
  } else {
    $selection = $apps | Where-Object { $_.AllowedActions -contains $Action -and (($Action -eq 'Install' -and $_.InstallState -eq 'NotInstalled') -or ($Action -eq 'Uninstall' -and $_.InstallState -eq 'Installed' -and -not $_.Deadline)) } |
    Select-Object Publisher, Name, SoftwareVersion, InstallState, @{Name = 'ReleaseDate'; Expression = { $_.ConvertToDateTime($_.ReleaseDate).ToShortDateString() } }, Id -Unique |
    sort Name | Out-GridView -Title "$ComputerName`: Select App to $Action" -PassThru

    if (-not $selection) {
		    throw 'No selection made.'
    } elseif ($selection -is [array]) {
		    throw 'Only one selection is allowed.'
    } else {
		    [psobject]$app = $apps | Where-Object { $_.Id -eq $selection.Id } | Select-Object Id, Name, Revision, IsMachineTarget -First 1

		    [int]$code = Invoke-WmiMethod @params -Name $Action -ArgumentList @(0, $app.Id, $app.IsMachineTarget, $false, 'High', $app.Revision) | Select-Object -ExpandProperty ReturnValue

      $action = $action.ToLower()
      if ($code -ne 0) {
        throw "Error invoking $action of '$($app.Name)' ($code)."
      } else {
        "Successfully invoked $action of '$($app.Name)'."
      }
    }
  }
}

Invoke-CmAppAction -ComputerName 'Computer123' -Action Install
