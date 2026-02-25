-- Executor ROLE

-- Grant execute para todos os objectos de uma BD
USE RUP
--GRANT EXECUTE TO db_executor
EXEC sp_addrolemember 'db_executor',[cofidis2000\comunicacoes]
go

-- ou a um particular objecto

USE RUP;   
GRANT EXECUTE ON OBJECT::dbo.COF_ADD_ContactoTelefonico  TO [cofidis2000\comunicacoes];  
GO  


/*
USE RUP
EXEC sp_addrolemember 'db_executor','[cofidis2000\comunicacoes]'
go

use idh
DECLARE @command varchar(1000) 
SELECT @command = 'USE [?] CREATE ROLE db_executor' 
EXEC sp_MSforeachdb @command 
*/


-------------------------------  

-- Para criar SPs e alterar

-- Database specific
CREATE ROLE db_StoredProcedure_View
GRANT VIEW DEFINITION TO db_All_StoredProc_View
go

/* CREATE A NEW ROLE - Any schema alter and create procedure permissions */
-- Database specific
CREATE ROLE db_CreateStoredProc_AlterSchema
GRANT ALTER ANY SCHEMA TO db_CreateStoredProc_AlterSchema
GRANT CREATE PROCEDURE TO db_CreateStoredProc_AlterSchema
GO