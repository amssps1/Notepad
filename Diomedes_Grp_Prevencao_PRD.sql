-- [-- DB CONTEXT --] --
USE [ContactCenter360]
 
-- [-- DB USERS --] --
 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'CDM\almeidda') BEGIN CREATE USER  [CDM\almeidda] FOR LOGIN [CDM\almeidda] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'CDM\COUTINRA') BEGIN CREATE USER  [CDM\COUTINRA] FOR LOGIN [CDM\COUTINRA] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'CDM\domingrc') BEGIN CREATE USER  [CDM\domingrc] FOR LOGIN [CDM\domingrc] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'CDM\gomesne') BEGIN CREATE USER  [CDM\gomesne] FOR LOGIN [CDM\gomesne] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'CDM\jesussa') BEGIN CREATE USER  [CDM\jesussa] FOR LOGIN [CDM\jesussa] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'CDM\MIRANMA') BEGIN CREATE USER  [CDM\MIRANMA] FOR LOGIN [CDM\MIRANMA] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'CDM\RAMALHLA') BEGIN CREATE USER  [CDM\RAMALHLA] FOR LOGIN [CDM\RAMALHLA] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'CDM\VEIGAIN') BEGIN CREATE USER  [CDM\VEIGAIN] FOR LOGIN [CDM\VEIGAIN] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'COFIDIS2000\GRP_SQL_DADOS_MODELOS_PREV') BEGIN CREATE USER  [COFIDIS2000\GRP_SQL_DADOS_MODELOS_PREV] FOR LOGIN [COFIDIS2000\GRP_SQL_DADOS_MODELOS_PREV] WITH DEFAULT_SCHEMA = [COFIDIS2000\GRP_SQL_DADOS_MODELOS_PREV] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'COFIDIS2000\grpSQLSuporteAplicacional') BEGIN CREATE USER  [COFIDIS2000\grpSQLSuporteAplicacional] FOR LOGIN [COFIDIS2000\grpSQLSuporteAplicacional] WITH DEFAULT_SCHEMA = [COFIDIS2000\grpSQLSuporteAplicacional] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'COFIDIS2000\PIRS_SVC_UNN') BEGIN CREATE USER  [COFIDIS2000\PIRS_SVC_UNN] FOR LOGIN [COFIDIS2000\PIRS_SVC_UNN] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'dbo') BEGIN CREATE USER  [dbo] FOR LOGIN [dbo] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'guest') BEGIN CREATE USER  [guest] FOR LOGIN [guest] WITH DEFAULT_SCHEMA = [guest] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'ODBC_Diomedes') BEGIN CREATE USER  [ODBC_Diomedes] FOR LOGIN [ODBC_Diomedes] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'ODBC_Diomedes_Hades') BEGIN CREATE USER  [ODBC_Diomedes_Hades] FOR LOGIN [ODBC_Diomedes_Hades] WITH DEFAULT_SCHEMA = [dbo] END; 
IF NOT EXISTS (SELECT [name] FROM sys.database_principals WHERE [name] =  'PROD_SRV_PREVCHMSCL') BEGIN CREATE USER  [PROD_SRV_PREVCHMSCL] FOR LOGIN [PROD_SRV_PREVCHMSCL] WITH DEFAULT_SCHEMA = [dbo] END; 
-- [-- DB ROLES --] --
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'CDM\COUTINRA'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'CDM\gomesne'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'CDM\jesussa'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'CDM\MIRANMA'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'CDM\RAMALHLA'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'CDM\VEIGAIN'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'COFIDIS2000\Grp Responsaveis Onboarding'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'COFIDIS2000\Grp Sector Analise Funcional'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'COFIDIS2000\Grp Servico Controlo e Acompanhamentos das Operacoes'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'COFIDIS2000\Grp Servico Dados e Modelos'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'COFIDIS2000\GRP_Diomedes-CC360'
EXEC sp_addrolemember @rolename = 'db_datareader', @membername = 'COFIDIS2000\PIRS_SVC_UNN'
EXEC sp_addrolemember @rolename = 'db_datawriter', @membername = 'CDM\COUTINRA'
EXEC sp_addrolemember @rolename = 'db_datawriter', @membername = 'CDM\gomesne'
EXEC sp_addrolemember @rolename = 'db_owner', @membername = 'CDM\almeidda'
EXEC sp_addrolemember @rolename = 'db_owner', @membername = 'ODBC_Diomedes'
EXEC sp_addrolemember @rolename = 'db_owner', @membername = 'ODBC_Diomedes_Hades'
 
-- [-- OBJECT LEVEL PERMISSIONS --] --
DENY EXECUTE ON [dbo].[fn_diagramobjects] TO [guest]
DENY EXECUTE ON [dbo].[sp_alterdiagram] TO [guest]
DENY EXECUTE ON [dbo].[sp_creatediagram] TO [guest]
DENY EXECUTE ON [dbo].[sp_dropdiagram] TO [guest]
DENY EXECUTE ON [dbo].[sp_helpdiagramdefinition] TO [guest]
DENY EXECUTE ON [dbo].[sp_helpdiagrams] TO [guest]
DENY EXECUTE ON [dbo].[sp_renamediagram] TO [guest]
GRANT EXECUTE ON [dbo].[fn_diagramobjects] TO [public]
GRANT EXECUTE ON [dbo].[sp_alterdiagram] TO [public]
GRANT EXECUTE ON [dbo].[sp_creatediagram] TO [public]
GRANT EXECUTE ON [dbo].[sp_dropdiagram] TO [public]
GRANT EXECUTE ON [dbo].[sp_helpdiagramdefinition] TO [public]
GRANT EXECUTE ON [dbo].[sp_helpdiagrams] TO [public]
GRANT EXECUTE ON [dbo].[sp_renamediagram] TO [public]
GRANT SELECT ON [dbo].[agent_information] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[answer] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[bo_configuration_questions] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[bo_configurations] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[bo_email] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[bo_email_accounts] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[bo_feature] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[bo_finesse] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[bo_machines] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[bo_script] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[bo_script_template_chat] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[bo_script_template_email] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[bo_uccx] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[bo_usex] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[call_contact_entry] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[call_contact_state_audit] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[call_details] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[call_manager_config] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[campaign_product_relation] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[categoria] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[categoria_sub_categorias] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[chat] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[chat_contact_entry] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[chat_contact_entry] TO [PROD_SRV_PREVCHMSCL]
GRANT SELECT ON [dbo].[chat_contact_state_audit] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[chat_file] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[clients] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[contact] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[contact_contact_email] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[contact_contact_phone] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[contact_email] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[contact_phone] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[csq_email_address] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[csq_product_relation] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[degreekinship] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[destinatario] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[email_address] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[email_attachment] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[email_contact_entry] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[email_contact_state_audit] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[end_points_config] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[exchange_account] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[exchange_email] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[exchange_email_emailbody] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[faq] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[faq_analytics] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[faq_linha_atend_list] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[finesse_config] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[history] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[linha_atend] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[linha_atend_categorias] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[linha_atend_config] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[linha_atend_destinatarios] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[motivo] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[participant] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[placeofdeath] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[property] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[protocol] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[question] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[question_translation] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[register] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[register_state_audit] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[servicetype] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[skill] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[skill_call_config] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[skill_chat_config] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[skill_email_config] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[skill_external_config] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[social_contact_entry] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[social_miner_config] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[store] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[sub_categoria] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[sub_categoria_motivos] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[subject] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[token] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[transcript_chat] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[uccx_config] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[usex] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[usex_call] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[usex_client] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT ON [dbo].[video_call_control] TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
 
-- [--DB LEVEL PERMISSIONS --] --
GRANT ALTER TO [COFIDIS2000\GRP_SQL_DADOS_MODELOS_PREV]
GRANT CONNECT TO [CDM\almeidda]
GRANT CONNECT TO [CDM\COUTINRA]
GRANT CONNECT TO [CDM\domingrc]
GRANT CONNECT TO [CDM\gomesne]
GRANT CONNECT TO [CDM\jesussa]
GRANT CONNECT TO [CDM\MIRANMA]
GRANT CONNECT TO [CDM\RAMALHLA]
GRANT CONNECT TO [CDM\VEIGAIN]
GRANT CONNECT TO [COFIDIS2000\Grp Responsaveis Onboarding]
GRANT CONNECT TO [COFIDIS2000\Grp Sector Analise Funcional]
GRANT CONNECT TO [COFIDIS2000\Grp Servico Controlo e Acompanhamentos das Operacoes]
GRANT CONNECT TO [COFIDIS2000\Grp Servico Dados e Modelos]
GRANT CONNECT TO [COFIDIS2000\Grp Servico Monitorizacao e Suporte Comercial]
GRANT CONNECT TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT CONNECT TO [COFIDIS2000\GRP_Diomedes-CC360]
GRANT CONNECT TO [COFIDIS2000\GRP_SQL_DADOS_MODELOS_PREV]
GRANT CONNECT TO [COFIDIS2000\grpSQLSuporteAplicacional]
GRANT CONNECT TO [COFIDIS2000\PIRS_SVC_UNN]
GRANT CONNECT TO [ODBC_Diomedes]
GRANT CONNECT TO [ODBC_Diomedes_Hades]
GRANT CONNECT TO [PROD_SRV_PREVCHMSCL]
GRANT EXECUTE TO [COFIDIS2000\GRP_SQL_DADOS_MODELOS_PREV]
GRANT EXECUTE TO [COFIDIS2000\grpSQLSuporteAplicacional]
GRANT INSERT TO [COFIDIS2000\GRP_SQL_DADOS_MODELOS_PREV]
GRANT SELECT TO [COFIDIS2000\Grp Responsaveis Onboarding]
GRANT SELECT TO [COFIDIS2000\Grp Setor Marketing Intelligence & Innovation]
GRANT SELECT TO [COFIDIS2000\GRP_SQL_DADOS_MODELOS_PREV]
GRANT SELECT TO [COFIDIS2000\grpSQLSuporteAplicacional]
GRANT SHOWPLAN TO [COFIDIS2000\GRP_SQL_DADOS_MODELOS_PREV]
GRANT SHOWPLAN TO [COFIDIS2000\grpSQLSuporteAplicacional]
GRANT UPDATE TO [COFIDIS2000\GRP_SQL_DADOS_MODELOS_PREV]
GRANT VIEW DATABASE STATE TO [COFIDIS2000\grpSQLSuporteAplicacional]
GRANT VIEW DEFINITION TO [COFIDIS2000\GRP_SQL_DADOS_MODELOS_PREV]
GRANT VIEW DEFINITION TO [COFIDIS2000\grpSQLSuporteAplicacional]
 
-- [--DB LEVEL SCHEMA PERMISSIONS --] --

Completion time: 2023-07-11T18:34:56.4005446+01:00
