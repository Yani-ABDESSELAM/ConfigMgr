-- YO, THESE QUERIES AREN'T SUPPORTED BY MICROSOFT!
-- USE AT YOUR OWN RISK!!!

-- Finds all devices that are spitting out errors with inventory scans.
SELECT il.MachineID as ResourceID, sd.Netbios_Name0 as Name,
  dbo.fnConvertUTCToLocal(il.LogTime) AS LogLocalTime,
  il.LogTime as LogUtcTime,
  il.LogSource,
  CAST(il.ServerReportVersion/4294967296 as int) as ServerMajor,
  il.ServerReportVersion%4294967296 as ServerMinor,
  CAST(il.ClientReportVersion/4294967296 as int) as ClientMajor,
  il.ClientReportVersion%4294967296 as ClientMinor,
  il.LogText,
  il.LogDetail
FROM InventoryLog il left Join System_DISC sd on il.MachineID = sd.ItemKey
