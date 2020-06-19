-- YO, THESE QUERIES AREN'T SUPPORTED BY MICROSOFT!
-- USE AT YOUR OWN RISK!!!

-- This query will give you a list of every failed inventory log entry by device where the failed entry occurred AFTER the last successful inventory was reported for that device.
-- It also includes the failure count since the last successful inventory (the total is included on each row for a given device).
SELECT
  il.Name
  , il.LogLocalTime
  , il.ServerMajor
  , il.ServerMinor
  , il.ClientMajor
  , il.ClientMinor
  , il.ResourceID
  , il.logText
  , il.LogDetail
  , mil.LastFullSync
  , COUNT(il.ResourceID) OVER (PARTITION BY il.ResourceID) as FailureCount
FROM
  vInventoryLog il
  LEFT OUTER JOIN
  (
  SELECT
    ResourceID 
    , MAX(LogUtcTime) as LastFullSync
  FROM
    vInventoryLog
  WHERE 
    LogText = 'full/resync report'
  GROUP BY
    ResourceID
  ) as mil ON mil.ResourceID = il.resourceID
WHERE
  il.LogUtcTime > mil.LastFullSync
  AND Name IS NOT NULL
ORDER BY
  FailureCount DESC
  ,Name Desc
  ,LogLocalTime DESC