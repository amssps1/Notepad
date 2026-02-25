-- PRD- ARTEMIS
--  COFIDIS2000\GRP_SQL_EXT_PRD  (Moisés)
--  

use master
go
IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'COFIDIS2000\GRP_SQL_EXT_PRD')
     DROP LOGIN [COFIDIS2000\GRP_SQL_EXT_PRD];
GO  

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'COFIDIS2000\GRP_SQL_EXT_PRD')
     CREATE LOGIN [COFIDIS2000\GRP_SQL_EXT_PRD] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english];
GO    


EXEC sp_MSforeachdb '
IF ''?'' IN (''DB_Cofidis_DAH'', ''PartnerBorderaux'') 
BEGIN 
    USE [?]
    PRINT ''?''
	DROP USER IF EXISTS [COFIDIS2000\GRP_SQL_EXT_PRD]

    IF DATABASE_PRINCIPAL_ID(''COFIDIS2000\GRP_SQL_EXT_PRD'') IS NULL
    BEGIN
        PRINT '' Criando o user.''
        CREATE USER [COFIDIS2000\GRP_SQL_EXT_PRD] FROM LOGIN [COFIDIS2000\GRP_SQL_EXT_PRD];
    END /*IF*/
    PRINT '' Adicionar as permissões para o user ...''
    grant select on PERSEU.DB_Cofidis_DAH.dbo.Dossier TO [COFIDIS2000\GRP_SQL_EXT_PRD]
	GRANT SHOWPLAN 				TO [COFIDIS2000\GRP_SQL_EXT_PRD]

END /*IF*/
'

-----

