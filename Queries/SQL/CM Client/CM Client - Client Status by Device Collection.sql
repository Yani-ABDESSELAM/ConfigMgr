-- Configuration Manager - Client Status by Device Collection

SELECT s.Name0,s.User_Domain0,
CASE Client0 WHEN '0' THEN 'No' WHEN '1' THEN 'Yes' ELSE 'Unknown' END AS [Client Status]
FROM v_r_system s

-- Specify the Collection ID before running!
JOIN _RES_COLL_SMS00001 AS coll ON S.Name0=coll.name

--------------------------------------------------------------------------------------------------------------------------

SELECT
sys.Name0 AS 'Computer Name',
sys.User_Name0 AS 'User Name',
summ.ClientStateDescription,
CASE WHEN summ.ClientActiveStatus = 0 THEN 'Inactive'
WHEN summ.ClientActiveStatus = 1 THEN 'Active'
END AS 'ClientActiveStatus',
summ.LastActiveTime,
CASE WHEN summ.IsActiveDDR = 0 THEN 'Inactive'
WHEN summ.IsActiveDDR = 1 THEN 'Active'
END AS 'IsActiveDDR',
CASE WHEN summ.IsActiveHW = 0 THEN 'Inactive'
WHEN summ.IsActiveHW = 1 THEN 'Active'
END AS 'IsActiveHW',
CASE WHEN summ.IsActiveSW = 0 THEN 'Inactive'
WHEN summ.IsActiveSW = 1 THEN 'Active'
END AS 'IsActiveSW',
CASE WHEN summ.ISActivePolicyRequest = 0 THEN 'Inactive'
WHEN summ.ISActivePolicyRequest = 1 THEN 'Active'
END AS 'ISActivePolicyRequest',
CASE WHEN summ.IsActiveStatusMessages = 0 THEN 'Inactive'
WHEN summ.IsActiveStatusMessages = 1 THEN 'Active'
END AS 'IsActiveStatusMessages',
summ.LastOnline,
summ.LastDDR,
summ.LastHW,
summ.LastSW,
summ.LastPolicyRequest,
summ.LastStatusMessage,
summ.LastHealthEvaluation,
CASE WHEN LastHealthEvaluationResult = 1 THEN 'Not Yet Evaluated'
WHEN LastHealthEvaluationResult = 2 THEN 'Not Applicable'
WHEN LastHealthEvaluationResult = 3 THEN 'Evaluation Failed'
WHEN LastHealthEvaluationResult = 4 THEN 'Evaluated Remediated Failed'
WHEN LastHealthEvaluationResult = 5 THEN 'Not Evaluated Dependency Failed'
WHEN LastHealthEvaluationResult = 6 THEN 'Evaluated Remediated Succeeded'
WHEN LastHealthEvaluationResult = 7 THEN 'Evaluation Succeeded'
END AS 'Last Health Evaluation Result',
CASE WHEN LastEvaluationHealthy = 1 THEN 'Pass'
WHEN LastEvaluationHealthy = 2 THEN 'Fail'
WHEN LastEvaluationHealthy = 3 THEN 'Unknown'
END AS 'Last Evaluation Healthy',
CASE WHEN summ.ClientRemediationSuccess = 1 THEN 'Pass'
WHEN summ.ClientRemediationSuccess = 2 THEN 'Fail'
ELSE ''
END AS 'ClientRemediationSuccess',
summ.ExpectedNextPolicyRequest
FROM v_CH_ClientSummary summ
INNER JOIN v_R_System sys ON summ.ResourceID = sys.ResourceID
JOIN _RES_COLL_SMS00001 AS coll ON SYS.Name0=coll.name

ORDER BY sys.Name0
