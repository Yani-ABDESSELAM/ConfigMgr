select SMS_R_SYSTEM.ResourceID, SMS_R_SYSTEM.ResourceType, SMS_R_SYSTEM.Name, SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_System.OperatingSystemNameandVersion,
SMS_R_SYSTEM.ResourceDomainORWorkgroup, SMS_R_SYSTEM.Client
from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like "Microsoft Windows NT Server 10.0%"
OR SMS_R_System.OperatingSystemNameandVersion like "Microsoft Windows NT Advanced Server 10.0%"