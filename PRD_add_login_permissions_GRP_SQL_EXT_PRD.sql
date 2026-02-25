-- PRD- Perseu/EOS
--  cofidis2000\migraamostra  (Migraamostra)
--  

use master
go
--IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'cofidis2000\migraamostra')
--     DROP LOGIN [cofidis2000\migraamostra];
--GO  

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'cofidis2000\migraamostra')
     CREATE LOGIN [cofidis2000\migraamostra] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english];
GO    


EXEC sp_MSforeachdb '
IF ''?'' IN (''DB_Cofidis_DAH'',''AdministracaoSistemas''
,''ComunicacaoParceiros''
,''db_cofidis_alteracoes''
,''db_cofidis_dah_interface''

,''RiskLevel''
,''db_cofidis_dah_transactionlog''
,''db_cofidis_dah_interface_aux''
,''dba_db''
,''ExtratoCofidis''
,''FactCofidis''
,''Interfacesdah''
,''Loms''
,''ReconciliacaoBancaria''
,''ControlosPermanentes''

,''PartnerBorderaux'') 
BEGIN 
    USE [?]
    PRINT ''?''
	DROP USER IF EXISTS [cofidis2000\migraamostra]

    IF DATABASE_PRINCIPAL_ID(''cofidis2000\migraamostra'') IS NULL
    BEGIN
        PRINT '' Criando o user.''
        CREATE USER [cofidis2000\migraamostra] FROM LOGIN [cofidis2000\migraamostra];
    END /*IF*/
    PRINT '' Adicionar as permissões para o user ...''
    grant select TO [cofidis2000\migraamostra]
	grant view definition TO [cofidis2000\migraamostra]

END /*IF*/
'

-----
--select * from sys.databases
