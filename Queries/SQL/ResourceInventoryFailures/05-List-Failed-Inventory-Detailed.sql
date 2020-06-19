-- YO, THESE QUERIES AREN'T SUPPORTED BY MICROSOFT!
-- USE AT YOUR OWN RISK!!!

SELECT
  DISTINCT
  il.Name
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
  FailureCount desc