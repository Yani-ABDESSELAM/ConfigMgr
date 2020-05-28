/* NOTE: THIS IS NOT A SQL FILE! This was saved as a SQL file for IDE color-coding purposes only! */
/* NOTE: THIS IS NOT A SQL FILE! This was saved as a SQL file for IDE color-coding purposes only! */
/* NOTE: THIS IS NOT A SQL FILE! This was saved as a SQL file for IDE color-coding purposes only! */

SELECT
SMS_R_SYSTEM.ResourceID,
SMS_R_SYSTEM.ResourceType,
SMS_R_SYSTEM.Name,
SMS_R_SYSTEM.SMSUniqueIdentifier,
SMS_R_SYSTEM.ResourceDomainORWorkgroup,
SMS_R_SYSTEM.Client

FROM
SMS_R_System

INNER JOIN
SMS_G_System_DISK

ON
SMS_G_System_DISK.ResourceID = SMS_R_System.ResourceId

WHERE
SMS_G_System_DISK.Index > 0

ORDER BY
SMS_R_System.Name
