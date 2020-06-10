-- Configuration Manager - All Applications Installed on Device Collections

SELECT DISTINCT dbo.v_R_System.Netbios_Name0, dbo.v_R_System.AD_Site_Name0, dbo.v_GS_ADD_REMOVE_PROGRAMS.DisplayName0, dbo.v_GS_OPERATING_SYSTEM.Caption0
FROM dbo.v_R_System
  INNER JOIN dbo.v_GS_ADD_REMOVE_PROGRAMS ON dbo.v_R_System.ResourceID = dbo.v_GS_ADD_REMOVE_PROGRAMS.ResourceID
  INNER JOIN dbo.v_GS_OPERATING_SYSTEM ON dbo.v_R_System.ResourceID = dbo.v_GS_OPERATING_SYSTEM.ResourceID
  
  -- Specify the Collection ID before running!
  JOIN _RES_COLL_SMS00001 AS coll ON S.Name0=coll.name
