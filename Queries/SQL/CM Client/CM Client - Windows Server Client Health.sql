Declare @CollectionID as Varchar(8)
Declare @Total as Numeric(8)
Declare @Healthy as Numeric(8)
Declare @Unhealthy as Numeric(8)
Declare @HWInventoryOK as Numeric(8)
Declare @HWInventoryNotOK as Numeric(8)
Declare @SWInventoryOK as Numeric(8)
Declare @SWInventoryNotOK as Numeric(8)
Declare @WSUSInventoryOK as Numeric(8)
Declare @WSUSInventoryNotOK as Numeric(8)
Set @CollectionID = 'SMS00001' -- specify scope collection ID
select @Total = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID and ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
)
select @Healthy = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
)
select @Unhealthy = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and ResourceID Not in (select ResourceID from v_FullCollectionMembership where CollectionID =
@CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 ) and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
)
select @HWInventoryOK = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
and ResourceID in (select ResourceID from v_GS_WORKSTATION_STATUS where DATEDIFF
(day,LastHWScan,GetDate())<30)
)
select @HWInventoryNotOK = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in ( select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
and ResourceID Not in (select ResourceID from v_GS_WORKSTATION_STATUS where DATEDIFF
(day,LastHWScan,GetDate())<30)
)
select @SWInventoryOK = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
and ResourceID in (select ResourceID from v_GS_LastSoftwareScan where DATEDIFF
(day,LastScanDate,GetDate())<30)
)
select @SWInventoryNotOK = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
and ResourceID Not in (select ResourceID from v_GS_LastSoftwareScan where DATEDIFF
(day,LastScanDate,GetDate())<30)
)
select @WSUSInventoryOK = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
and ResourceID in (select ResourceID from v_UpdateScanStatus where lastErrorCode = 0 and DATEDIFF
(day,LastScanTime,GetDate())<30)
)
select @WSUSInventoryNotOK = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
and ResourceID Not in (select ResourceID from v_UpdateScanStatus where lastErrorCode = 0 and DATEDIFF
(day,LastScanTime,GetDate())<30)
)
select
@Total as 'Total',
@Healthy as 'Healthy',
@Unhealthy as 'Unhealthy',
@HWInventoryOK as 'HW<30Days',
@HWInventoryNotOK as 'HW>30Days',
@SWInventoryOK as 'SW<30Days',
@SWInventoryNotOK as 'SW>30Days',
@WSUSInventoryOK as 'WSUS<30Days',
@WSUSInventoryNotOK as 'WSUS>30Days',
case when (@Total = 0) or (@Total is null) Then '0' Else (round(@Healthy/ convert
(float,@Total)*100,2)) End as 'Healthy%',
case when (@Healthy = 0) or (@Healthy is null) Then '0' Else (round(@HWInventoryOK/ convert
(float,@Healthy)*100,2)) End as 'HW%',
case when (@Healthy = 0) or (@Healthy is null) Then '0' Else (round(@SWInventoryOK/ convert
(float,@Healthy)*100,2)) End as 'SW%',
case when (@Healthy = 0) or (@Healthy is null) Then '0' Else (round(@WSUSInventoryOK/ convert
(float,@Healthy)*100,2)) End as 'WSUS%'
Declare @CollectionID as Varchar(8)
Declare @Total as Numeric(8)
Declare @Healthy as Numeric(8)
Declare @Unhealthy as Numeric(8)
Declare @HWInventoryOK as Numeric(8)
Declare @HWInventoryNotOK as Numeric(8)
Declare @SWInventoryOK as Numeric(8)
Declare @SWInventoryNotOK as Numeric(8)
Declare @WSUSInventoryOK as Numeric(8)
Declare @WSUSInventoryNotOK as Numeric(8)
Set @CollectionID = 'SMS00001' -- specify scope collection ID
select @Total = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID and ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
)
select @Healthy = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
)
select @Unhealthy = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and ResourceID Not in (select ResourceID from v_FullCollectionMembership where CollectionID =
@CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 ) and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
)
select @HWInventoryOK = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
and ResourceID in (select ResourceID from v_GS_WORKSTATION_STATUS where DATEDIFF
(day,LastHWScan,GetDate())<30)
)
select @HWInventoryNotOK = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in ( select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
and ResourceID Not in (select ResourceID from v_GS_WORKSTATION_STATUS where DATEDIFF
(day,LastHWScan,GetDate())<30)
)
select @SWInventoryOK = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
and ResourceID in (select ResourceID from v_GS_LastSoftwareScan where DATEDIFF
(day,LastScanDate,GetDate())<30)
)
select @SWInventoryNotOK = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
and ResourceID Not in (select ResourceID from v_GS_LastSoftwareScan where DATEDIFF
(day,LastScanDate,GetDate())<30)
)
select @WSUSInventoryOK = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
and ResourceID in (select ResourceID from v_UpdateScanStatus where lastErrorCode = 0 and DATEDIFF
(day,LastScanTime,GetDate())<30)
)
select @WSUSInventoryNotOK = (
select COUNT(*) from v_FullCollectionMembership where CollectionID = @CollectionID
and IsAssigned = 1 and IsActive = 1 and IsObsolete = 0 and IsClient = 1 and
ResourceID in (
select ResourceID from v_R_System where Operating_System_Name_and0 like '%Server%')
and ResourceID Not in (select ResourceID from v_UpdateScanStatus where lastErrorCode = 0 and DATEDIFF
(day,LastScanTime,GetDate())<30)
)
select
@Total as 'Total',
@Healthy as 'Healthy',
@Unhealthy as 'Unhealthy',
@HWInventoryOK as 'HW<30Days',
@HWInventoryNotOK as 'HW>30Days',
@SWInventoryOK as 'SW<30Days',
@SWInventoryNotOK as 'SW>30Days',
@WSUSInventoryOK as 'WSUS<30Days',
@WSUSInventoryNotOK as 'WSUS>30Days',
case when (@Total = 0) or (@Total is null) Then '0' Else (round(@Healthy/ convert
(float,@Total)*100,2)) End as 'Healthy%',
case when (@Healthy = 0) or (@Healthy is null) Then '0' Else (round(@HWInventoryOK/ convert
(float,@Healthy)*100,2)) End as 'HW%',
case when (@Healthy = 0) or (@Healthy is null) Then '0' Else (round(@SWInventoryOK/ convert
(float,@Healthy)*100,2)) End as 'SW%',
case when (@Healthy = 0) or (@Healthy is null) Then '0' Else (round(@WSUSInventoryOK/ convert
(float,@Healthy)*100,2)) End as 'WSUS%'
