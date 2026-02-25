
EXEC sp_MSforeachdb '
IF ''?'' IN (''IDH'', ''DotnetNuke'', ''DSTI'', ''Outsystems'') 
BEGIN 
    USE [?]

	IF DATABASE_PRINCIPAL_ID(''COFIDIS2000\grpSQLServicedesk'') IS NOT NULL
    BEGIN
	    PRINT ''?''
	--ALTER AUTHORIZATION ON SCHEMA::[CDM\juniorse] TO [dbo]
	   DROP USER IF EXISTS [COFIDIS2000\grpSQLServicedesk]
    END

END /*IF*/
'
--		 ALTER AUTHORIZATION ON SCHEMA::[usrDW24J] TO [dbo]
use master
go
IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'CDM\juniorse')
     DROP LOGIN [CDM\juniorse];
GO  
