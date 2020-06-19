-- YO, THESE QUERIES AREN'T SUPPORTED BY MICROSOFT!
-- USE AT YOUR OWN RISK!!!

--Total Inventory Type
SELECT
  DISTINCT
  LogText,
  Count(*) as LogTextCount
FROM
  vInventoryLog
WHERE 
	Name IS NOT NULL
GROUP BY 
	LogText
ORDER BY 
	LogTextCount DESC

--Total Inventory Type by Device
SELECT
  DISTINCT
  ResourceID,
  LogText,
  Count(*) as LogTextCount
FROM
  vInventoryLog
WHERE
	Name IS NOT NULL
GROUP BY
	ResourceID,
	LogText
ORDER BY 
	LogTextCount DESC

--Oldest Log Entry
SELECT
  MIN(LogUtcTime) as OldestDateTime
FROM
  vInventoryLog
WHERE
	Name IS NOT NULL
