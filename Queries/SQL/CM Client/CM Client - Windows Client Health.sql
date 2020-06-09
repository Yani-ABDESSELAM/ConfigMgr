Declare @CollectionID as Varchar(8)
Set @CollectionID = 'SMS00001' --Specify the collection ID
select distinct(Name),Case when IsClient= 1 then 'Healthy' else 'Unhealthy' end as 'HealthStatus',
(select case when count (v_GS_WORKSTATION_STATUS.ResourceID)=1 then 'Healthy' else 'Unhealthy' end
from v_GS_WORKSTATION_STATUS where DATEDIFF (day,LastHWScan,GetDate())<31 and
ResourceID=v_FullCollectionMembership.ResourceID)
as 'HWScanStatus',
(select case when count (v_GS_LastSoftwareScan.ResourceID)=1 then 'Healthy' else 'Unhealthy' end
from v_GS_LastSoftwareScan where DATEDIFF (day,LastScanDate,GetDate())<31 and
ResourceID=v_FullCollectionMembership.ResourceID)
as 'SWScanStatus',
(select case when count (v_UpdateScanStatus.ResourceID)=1 then 'Healthy' else 'Unhealthy' end
from v_UpdateScanStatus where DATEDIFF (day,LastScanTime,GetDate())<31 and LastErrorCode = 0 and
ResourceID=v_FullCollectionMembership.ResourceID)
as 'WSUSScanStatus',
(select DATEDIFF (day,LastHWScan,GetDate()) from v_GS_WORKSTATION_STATUS
where ResourceID=v_FullCollectionMembership.ResourceID)
as 'LastHWScanDays',
(select DATEDIFF (day,LastScanDate,GetDate()) from v_GS_LastSoftwareScan
where ResourceID=v_FullCollectionMembership.ResourceID)
as 'LastSWScanDays',
(select DATEDIFF (day,LastScanTime,GetDate()) from v_UpdateScanStatus
where LastErrorCode = 0 and ResourceID=v_FullCollectionMembership.ResourceID)
as 'LastWSUSScanDays'
from v_FullCollectionMembership where CollectionID = @CollectionID
and ResourceID in ( select ResourceID from v_R_System where Operating_System_Name_and0 like '%Workstation%')
order by 2 desc