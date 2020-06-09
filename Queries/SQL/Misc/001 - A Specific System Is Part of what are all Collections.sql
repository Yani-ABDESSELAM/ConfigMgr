Declare@Name Varchar(255)
Set@Name ='CLIENT01'--Provide Computer Name

Select
vrs.Name0,fcm.CollectionID,
Col.nameas'CollectionName',
vrs.Client0 fromv_R_System asVRSinnerjoinv_FullCollectionMembership asFCM onVRS.ResourceID=FCM.resourceIDinnerjoinv_Collection asCol onfcm.CollectionID=col.CollectionIDwhereVRS.Name0 =@Name andcol.CollectionID notlike'SMS%'orderbycol.Name
