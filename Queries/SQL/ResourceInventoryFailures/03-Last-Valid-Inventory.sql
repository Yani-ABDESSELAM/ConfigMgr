-- YO, THESE QUERIES AREN'T SUPPORTED BY MICROSOFT!
-- USE AT YOUR OWN RISK!!!

SELECT
  ResourceID,
  MAX(LogUtcTime) as LastFullSync
FROM
  vInventoryLog
WHERE 
  LogText = 'full/resync report'
GROUP BY
  ResourceID
