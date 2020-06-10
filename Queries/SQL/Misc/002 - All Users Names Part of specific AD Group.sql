DECLARE@GroupName varchar(255)
Set@GroupName ='%LAB-SCCM_Device_Adobe_Acrobat_Reader_11.0.03_EN%'--Provide Group Name

Select
vrug.User_Group_Name0 asGroupName,Vru.Name0 asUsername fromv_R_User asVruinnerjoinv_RA_User_UserGroupName asVrug onVru.ResourceID=Vrug.ResourceIDwhereVrug.User_Group_Name0 like @GroupName
