Function Disable-IncrementalUpdates { 
  <#
  #>
  [CmdletBinding(DefaultParameterSetName = "CollectionID")]
  Param ( 
    [Parameter(Mandatory = $true, ParameterSetName = "collectionID", Position = 0)][String]$CollectionID, 
    [Parameter(Mandatory = $true, ParameterSetName = "collectionName", Position = 0)][String]$CollectionName,
    [Parameter(Mandatory = $false, ParameterSetName = "collectionName", Position = 1)]
    [Parameter(Mandatory = $false, ParameterSetName = "collectionID", Position = 1)][String]$Server 
  )

  If (!$server) { 
    $server = '.' 
  }

  $siteCode = @(Get-WmiObject -Namespace root\sms -Class SMS_ProviderLocation -ComputerName $server)[0].SiteCodegwmi
  
  sms_collection -ComputerName $server -Namespace root\sms\site_$siteCode -Filter "CollectionID = '$collectionID' or Name = '$collectionName'" | 
  ForEach-Object { 
    $collection = [wmi] $_.__Path
    If ($collection.RefreshType -eq 4) { 
      $collection.RefreshType = 1 
    }
    If ($collection.RefreshType -eq 6) { 
      $Collection.RefreshType = 2 
    }
    $collection.Put() | Out-Null 
  } 
}

Function Enable-IncrementalUpdates { 
  <#
  #>
  [CmdletBinding(DefaultParameterSetName = "CollectionID")]
  Param ( 
    [Parameter(Mandatory = $true, ParameterSetName = "collectionID", Position = 0)][String]$CollectionID, 
    [Parameter(Mandatory = $true, ParameterSetName = "collectionName", Position = 0)][String]$CollectionName,
    [Parameter(Mandatory = $false, ParameterSetName = "collectionName", Position = 1)]
    [Parameter(Mandatory = $false, ParameterSetName = "collectionID", Position = 1)][String]$Server 
  )

  If (!$server) { 
    $server = '.' 
  }

  $siteCode = @(Get-WmiObject -Namespace root\sms -Class SMS_ProviderLocation -ComputerName $server)[0].SiteCodegwmi 

  sms_collection -ComputerName $server -Namespace root\sms\site_$siteCode -Filter "CollectionID = '$collectionID' or Name = '$collectionName'" | 
  ForEach-Object { 
    $collection = [wmi] $_.__Path 
    If ($collection.RefreshType -eq 1) { 
      $collection.RefreshType = 4 
    }
    If ($collection.RefreshType -eq 2) { 
      $Collection.RefreshType = 6 
    }
    $collection.Put() | Out-Null 
  }
}
