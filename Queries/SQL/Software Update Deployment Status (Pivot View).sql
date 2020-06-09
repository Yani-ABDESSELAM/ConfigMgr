-- Configuration Manager - Software Update Deployment Status (Pivot View)

SELECT Deploymentname, Available, Deadline,

  CAST(CAST(((CAST([Compliant] AS FLOAT) / (ISNULL([Compliant], 0) + ISNULL([Successfully installed update(s)], 0) + ISNULL([Pending system restart], 0) + ISNULL([Waiting for restart], 0) + ISNULL([Installing update(s)], 0) + ISNULL([Downloaded update(s)], 0) + ISNULL([Downloading update(s)], 0) + ISNULL([Waiting for another installation to complete], 0) + ISNULL([Waiting for maintenance window before installing], 0) + ISNULL([Enforcement state unknown], 0) + ISNULL([Failed to download update(s)], 0) + ISNULL([Failed to install update(s)], 0) ))*100) AS Numeric(10,2)) AS varchar(256)) + '%' AS '% Compliant',

  [Compliant],
  [Successfully installed update(s)],
  [Pending system restart],
  [Waiting for restart],
  [Installing update(s)],
  [Downloaded update(s)],
  [Downloading update(s)],
  [Waiting for another installation to complete],
  [Waiting for maintenance window before installing],
  [Enforcement state unknown],
  [Failed to download update(s)],
  [Failed to install update(s)]

FROM (
  SELECT
    a.Assignment_UniqueID AS DeploymentID,
    a.AssignmentName AS DeploymentName,
    a.StartTime AS Available,
    a.EnforcementDeadline AS Deadline,
    sn.StateName AS LastEnforcementState,
    count(*) AS NumberOfComputers
  FROM v_CIAssignment a
    JOIN v_AssignmentState_Combined assc
    ON a.AssignmentID=assc.AssignmentID
    JOIN v_StateNames sn
    ON assc.StateType = sn.TopicType AND sn.StateID=isnull(assc.StateID,0)

  GROUP BY a.Assignment_UniqueID, a.AssignmentName, a.StartTime, a.EnforcementDeadline,sn.StateName
) AS PivotData

PIVOT(
SUM (NumberOfComputers) FOR LastEnforcementState IN ( 
  [Compliant],
  [Successfully installed update(s)],
  [Pending system restart],
  [Waiting for restart],
  [Installing update(s)],
  [Downloaded update(s)],
  [Downloading update(s)],
  [Waiting for another installation to complete],
  [Waiting for maintenance window before installing],
  [Enforcement state unknown],
  [Failed to download update(s)],
  [Failed to install update(s)])
) AS pvt

-- Update the Deployment Name before running!
WHERE DeploymentName IN ('Deployment Name')

ORDER BY Deploymentname
