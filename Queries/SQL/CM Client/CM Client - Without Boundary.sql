-- Configuration Manager - Clients without a Boundary
SELECT DISTINCT
  v_R_System.Name0,
  v_R_System.Client0,
  v_RA_System_IPAddresses.IP_Addresses0,
  v_RA_System_IPSubnets.IP_Subnets0,
  v_RA_System_SMSAssignedSites.SMS_Assigned_Sites0
FROM v_R_System LEFT OUTER JOIN
  v_RA_System_IPSubnets ON v_R_System.ResourceID = v_RA_System_IPSubnets.ResourceID LEFT OUTER JOIN
  v_RA_System_IPAddresses ON v_R_System.ResourceID = v_RA_System_IPAddresses.ResourceID LEFT OUTER JOIN
  v_RA_System_SMSAssignedSites ON v_R_System.ResourceID = v_RA_System_SMSAssignedSites.ResourceID
WHERE (v_RA_System_SMSAssignedSites.SMS_Assigned_Sites0 IS NULL)
  AND (NOT (v_RA_System_IPAddresses.IP_Addresses0 IS NULL))
  AND (v_R_System.Client0 IS NULL)
  AND (NOT (v_RA_System_IPSubnets.IP_Subnets0 IS NULL))
ORDER BY v_RA_System_IPSubnets.IP_Subnets0
