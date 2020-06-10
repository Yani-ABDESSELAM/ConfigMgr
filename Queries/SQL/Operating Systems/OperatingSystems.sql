Select rs.ResourceID, rs.Name0, rs.Operating_System_Name_and0,
Case 
When rs.Operating_System_Name_and0 Like '%Workstation 6.1%' Then 'Windows 7' 
When rs.Operating_System_Name_and0 Like '%Workstation 6.3%' Then 'Windows 8.1' 
When rs.Operating_System_Name_and0 Like '%Workstation 10%' Then 'Windows 10' 
When rs.Operating_System_Name_and0 Like '%Server 5.2%' Then 'Windows Server 2003' 
When rs.Operating_System_Name_and0 Like '%Server 6.0%' Then 'Windows Server 2008' 
When rs.Operating_System_Name_and0 Like '%Server 6.1%' Then 'Windows Server 2008 R2' 
When rs.Operating_System_Name_and0 Like '%Server 6.2%' Then 'Windows Server 2012' 
When rs.Operating_System_Name_and0 Like '%Server 6.3%' Then 'Windows Server 2012 R2' 
uss.LastScanTime, DATEDIFF("d",uss.LastScanTime,getdate()) [Last Scan Days]
from v_r_system rs JOIN v_UpdateScanStatus uss on uss.ResourceID = rs.ResourceID where rs.Operating_System_Name_and0 like '%'+@OS+'%' 
AND (rs.Operating_System_Name_and0 NOT LIKE '%Workstation 5%' AND rs.Operating_System_Name_and0 NOT LIKE '%Workstation 6.0%' AND rs.Operating_System_Name_and0 NOT LIKE '%Workstation 6.2%') 
AND DATEDIFF("d",uss.LastScanTime,getdate()) <= @DaysScanned AND rs.Obsolete0 = 0