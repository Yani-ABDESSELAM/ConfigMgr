SELECT
vrs.Name0 AS 'ComputerName',
vrs.Client0 AS 'Client',
vrs.Operating_System_Name_and0 AS 'Operating System',
Vad.AgentTime AS 'LastHeartBeatTime'

FROM
v_R_System AS Vrs
INNER JOIN v_AgentDiscoveries
AS Vad
ON Vrs.ResourceID=Vad.ResourceId
WHERE vad.AgentName
LIKE '%Heartbeat Discovery'
