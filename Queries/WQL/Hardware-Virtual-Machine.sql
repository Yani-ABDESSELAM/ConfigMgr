/* NOTE: THIS IS NOT A SQL FILE! This was saved as a SQL file for IDE color-coding purposes only! */
/* NOTE: THIS IS NOT A SQL FILE! This was saved as a SQL file for IDE color-coding purposes only! */
/* NOTE: THIS IS NOT A SQL FILE! This was saved as a SQL file for IDE color-coding purposes only! */

SELECT
SMS_R_System.ResourceId,
SMS_R_System.ResourceType,
SMS_R_System.Name,
SMS_R_System.SMSUniqueIdentifier,
SMS_R_System.ResourceDomainORWorkgroup,
SMS_R_System.Client

FROM
SMS_R_System

WHERE
SMS_R_System.ResourceId

NOT IN (
  SELECT SMS_R_SYSTEM.ResourceID
  FROM SMS_R_System
  INNER JOIN SMS_G_System_COMPUTER_SYSTEM
  ON SMS_G_System_COMPUTER_SYSTEM.ResourceId = SMS_R_System.ResourceId
  WHERE SMS_G_System_COMPUTER_SYSTEM.Model
  LIKE "%Virtual%"
)