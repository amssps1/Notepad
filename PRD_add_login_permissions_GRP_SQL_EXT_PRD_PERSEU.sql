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
IF ''?'' IN (''PaymentGateway'') 
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
    grant select  				TO [COFIDIS2000\GRP_SQL_EXT_PRD]
	GRANT view definition 		TO [COFIDIS2000\GRP_SQL_EXT_PRD]

END /*IF*/
'

-----

USE IDH
go
grant select ON COF_Cliente	TO [COFIDIS2000\GRP_SQL_EXT_PRD]
grant select ON  COF_ClienteUProcesso	TO [COFIDIS2000\GRP_SQL_EXT_PRD]
grant select ON  COF_Processo	TO [COFIDIS2000\GRP_SQL_EXT_PRD]
grant select ON  Cof_baseriscoDAH	TO [COFIDIS2000\GRP_SQL_EXT_PRD]
grant select ON  COF_ContactoTelefonico	TO [COFIDIS2000\GRP_SQL_EXT_PRD]
grant select ON  DAH_Produto	TO [COFIDIS2000\GRP_SQL_EXT_PRD]
grant select ON  VG_CarteiraDossier	TO [COFIDIS2000\GRP_SQL_EXT_PRD]
grant select ON  OCR_PEDIDO 	TO [COFIDIS2000\GRP_SQL_EXT_PRD]
grant select ON  OCR_RESPOSTA	TO [COFIDIS2000\GRP_SQL_EXT_PRD]


/*	

967601447


Privilégios Ferreira

	

•	COF_Cliente
		o	Nome
		o	Primeiro Nome
		o	Ultimo Nome
		o	NumContribuinte
•	COF_ClienteUProcesso
		o	NIF
•	COF_Processo
•	Cof_baseriscoDAH
•	COF_Referencias
•	COF_ContactoTelefonico
		o	Numero
•	DAH_Produto
•	PERSEU.DB_Cofidis_DAH.dbo.Dossier
•	VG_CarteiraDossier
*/