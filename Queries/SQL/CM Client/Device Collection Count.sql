-- Configuration Manager - Device Collection Count
-- NOTE: Excludes 'All Systems' and 'All DEsktops and Servers' Collections!

SELECT v_R_System_Valid.Netbios_Name0, count(v_FullCollectionMembership.CollectionID) AS CollectionCount
FROM v_FullCollectionMembership
  INNER JOIN v_R_System_Valid
  ON v_R_System_Valid.ResourceID = v_FullCollectionMembership.ResourceID
WHERE v_FullCollectionMembership.CollectionID NOT IN ('SMSDM003','SMS00001')
GROUP BY v_R_System_Valid.Netbios_Name0
HAVING count(v_FullCollectionMembership.CollectionID) > 1
