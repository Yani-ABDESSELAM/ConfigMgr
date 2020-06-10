-- Configuration Manager - Server Hardware with Network Information

SELECT
  A.Name0,
  B.SerialNumber0 ,
  A.Manufacturer0,
  A.Model0,
  C.Name0 ,
  D.TotalPhysicalMemory0 ,

  MAX (J.MACAddress0) AS MAC ,
  MAX (F.IPAddress0) AS IPAddress ,
  G.AD_Site_Name0 ,
  MAX (A.UserName0) AS Username ,
  H.Caption0 ,
  H.CSDVersion0,
  G.Creation_Date0 ,
  I.LastHWScan


FROM
  v_GS_COMPUTER_SYSTEM A,
  v_GS_PC_BIOS B,
  v_GS_PROCESSOR C,
  v_GS_X86_PC_MEMORY D,
  v_GS_DISK E,
  v_GS_NETWORK_ADAPTER_CONFIGUR F,
  v_GS_NETWORK_ADAPTER J,
  v_GS_OPERATING_SYSTEM H,
  v_GS_WORKSTATION_STATUS I
  INNER JOIN
  v_R_System G ON G.ResourceID=I.ResourceID


WHERE
A.ResourceID = B.ResourceID AND
  A.ResourceID = C.ResourceID AND
  A.ResourceID = D.ResourceID AND
  A.ResourceID = E.ResourceID AND
  A.ResourceID = F.ResourceID AND
  A.ResourceID = G.ResourceID AND
  A.ResourceID = H.ResourceID AND
  A.ResourceID = I.ResourceID AND
  A.ResourceID = J.ResourceID AND
  H.Caption0 LIKE '%server%'

GROUP BY
  A.Name0,
  b.SerialNumber0,
  A.Manufacturer0, 
  A.Model0, 
  C.Name0, 
  D.TotalPhysicalMemory0, 
  G.AD_Site_Name0, 
  A.UserName0, 
  H.Caption0, 
  H.CSDVersion0, 
  G.Creation_Date0, 
  I.LastHWScan
