USE [dba_db]
GO
/****** Object:  StoredProcedure [dbo].[usp_Prevencao_GrantDelete]    Script Date: 16/01/2026 11:41:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   PROCEDURE [dbo].[usp_Prevencao_GrantDelete]
(
    @LoginCaller varchar(20)   -- login de quem chama a SP (ex: 'asilva', 'joao.p')
)
--WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        /* ============================================================
           CONFIG (HARDCODED)
           ============================================================ */
        DECLARE @Principal  sysname = N'COFIDIS2000\GRP_SQL_DELIVERY_PREV';
        DECLARE @SchemaName sysname = N'dbo';
        DECLARE @Minutes    int     = 5;

        -- Lista estática de DBs (hardcoded)
        DECLARE @DBs TABLE (DbName sysname NOT NULL PRIMARY KEY);
        INSERT INTO @DBs (DbName)
        VALUES
            (N'ASPState'),
(N'CobrancasDAH'),
(N'CofidisPayCore'),
(N'Cofinet'),
(N'Comunicacoes'),
(N'db_cofidis_dah'),
(N'dba_db'),
(N'DotNetNuke'),
(N'DSTI'),
(N'EngMetricsDB'),
(N'ExtraccaoTREC'),
(N'FileWatcher'),
(N'FM'),
(N'GestaoEconomato'),
(N'IDH'),
(N'LogginApp'),
(N'm-it2008'),
(N'Neptuno'),
(N'Oauth'),
(N'OSASPState'),
(N'OutSystems'),
(N'Partner360'),
(N'PartnerBorderaux'),
(N'PartnersIntegrations'),
(N'Paybylink'),
(N'RSK_Score'),
(N'RskCompetencias'),
(N'RskDecisao'),
(N'RUA'),
(N'RUP'),
(N'ScoreAuto'),
(N'ServiceGate'),
(N'TControl'),
(N'TcontrolDAH'),
(N'Threatmetrix');



        /* ============================================================
           TABELA DE LOG (com coluna LoginCaller)
           ============================================================ */
        IF OBJECT_ID('dbo.Log_Privilegios_Prevencao','U') IS NULL
        BEGIN
    
            
            CREATE TABLE dbo.Log_Privilegios_Prevencao
            (
                LogId           bigint IDENTITY(1,1) PRIMARY KEY,
                EventTime       datetime2(0) NOT NULL CONSTRAINT DF_LogPrev_EventTime DEFAULT (SYSDATETIME()),
                Action          varchar(20)  NOT NULL,   -- 'GRANT' | 'REVOKE' | 'ERROR_GRANT' | 'ERROR_REVOKE' | 'JOB_DELETE' | 'ERROR_JOB_DELETE'
                LoginCaller     varchar(20)  NULL,       -- <-- NOVO
                PrincipalName   sysname      NOT NULL,
                DatabaseName    sysname      NOT NULL,
                PermissionName  sysname      NOT NULL,   -- 'DELETE'
                ScopeType       varchar(20)  NOT NULL,   -- 'SCHEMA'
                ScopeName       sysname      NOT NULL,   -- 'dbo'
                ExpiresAt       datetime2(0) NULL,
                RequestedBy     sysname      NULL,
                JobName         sysname      NULL,
                Info            nvarchar(4000) NULL
            );

            CREATE INDEX IX_LogPrev_Recent
            ON dbo.Log_Privilegios_Prevencao (EventTime DESC, PrincipalName, DatabaseName);
        END
        ELSE
        BEGIN
            -- se a tabela já existir e não tiver a coluna, adiciona
            IF COL_LENGTH('dbo.Log_Privilegios_Prevencao', 'LoginCaller') IS NULL
                ALTER TABLE dbo.Log_Privilegios_Prevencao ADD LoginCaller varchar(20) NULL;
        END;

        /* ============================================================
           CALCULAR TEMPOS + NOMES (JOB + SCHEDULE)
           ============================================================ */
        DECLARE @ExpiresAt datetime2(0) = DATEADD(MINUTE, @Minutes, SYSDATETIME());
        DECLARE @JobName   sysname      = CONCAT(N'RevokeDeletePrev_', REPLACE(CONVERT(varchar(36), NEWID()),'-',''));
        DECLARE @SchedName sysname      = CONCAT(@JobName, N'_SCH');

        -- Evitar “race condition” dos segundos
        DECLARE @RunAt datetime = DATEADD(MINUTE, @Minutes, DATEADD(SECOND, -DATEPART(SECOND, GETDATE()), GETDATE()));
        IF @RunAt <= GETDATE() SET @RunAt = DATEADD(MINUTE, @Minutes + 1, GETDATE());

        DECLARE @RunDate int = CONVERT(int, CONVERT(char(8), @RunAt, 112));                 -- yyyymmdd
        DECLARE @RunTime int = CONVERT(int, REPLACE(CONVERT(char(8), @RunAt, 108),':','')); -- hhmmss

        /* ============================================================
           1) GRANT AGORA + LOG
           ============================================================ */
        DECLARE @db sysname;

        DECLARE db_cur CURSOR LOCAL FAST_FORWARD FOR
            SELECT DbName FROM @DBs;

        OPEN db_cur;
        FETCH NEXT FROM db_cur INTO @db;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            BEGIN TRY
                DECLARE @sql nvarchar(max) = N'
        USE ' + QUOTENAME(@db) + N';

        IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @P)
        BEGIN
            CREATE USER ' + QUOTENAME(@Principal) + N' FOR LOGIN ' + QUOTENAME(@Principal) + N';
        END;

        GRANT DELETE ON SCHEMA::' + QUOTENAME(@SchemaName) + N' TO ' + QUOTENAME(@Principal) + N';
        ';
                EXEC sp_executesql @sql, N'@P sysname', @P = @Principal;

                INSERT dbo.Log_Privilegios_Prevencao
                    (Action, LoginCaller, PrincipalName, DatabaseName, PermissionName, ScopeType, ScopeName, ExpiresAt, RequestedBy, JobName, Info)
                VALUES
                    ('GRANT', @LoginCaller, @Principal, @db, 'DELETE', 'SCHEMA', @SchemaName, @ExpiresAt, ORIGINAL_LOGIN(), @JobName,
                     CONCAT(N'GRANT DELETE ON SCHEMA; scheduled revoke at ', CONVERT(varchar(19), @RunAt, 120)));
            END TRY
            BEGIN CATCH
                INSERT dbo.Log_Privilegios_Prevencao
                    (Action, LoginCaller, PrincipalName, DatabaseName, PermissionName, ScopeType, ScopeName, ExpiresAt, RequestedBy, JobName, Info)
                VALUES
                    ('ERROR_GRANT', @LoginCaller, @Principal, @db, 'DELETE', 'SCHEMA', @SchemaName, @ExpiresAt, ORIGINAL_LOGIN(), @JobName,
                     CONCAT(N'Error ', ERROR_NUMBER(), N' (line ', ERROR_LINE(), N'): ', ERROR_MESSAGE()));
            END CATCH;

            FETCH NEXT FROM db_cur INTO @db;
        END

        CLOSE db_cur;
        DEALLOCATE db_cur;

        /* ============================================================
           2) PREPARAR COMANDOS DO JOB (LoginCaller embebido no código)
           ============================================================ */
        DECLARE @DbInserts nvarchar(max) = N'';
        SELECT @DbInserts = @DbInserts
            + N'INSERT INTO @DBs (DbName) VALUES (N''' + REPLACE(DbName,'''','''''') + N''');' + CHAR(10)
        FROM @DBs
        ORDER BY DbName;

        DECLARE @JobCmd_Revoke nvarchar(max) =
N'
DECLARE @LoginCaller varchar(20) = N''' + REPLACE(@LoginCaller,'''','''''') + N''';
DECLARE @Principal  sysname = N''' + REPLACE(@Principal,'''','''''') + N''';
DECLARE @SchemaName sysname = N''' + REPLACE(@SchemaName,'''','''''') + N''';
DECLARE @ExpiresAt  datetime2(0) = ''' + CONVERT(varchar(19), @ExpiresAt, 120) + N''';
DECLARE @JobName    sysname = N''' + REPLACE(@JobName,'''','''''') + N''';

DECLARE @DBs TABLE (DbName sysname NOT NULL PRIMARY KEY);
' + @DbInserts + N'

DECLARE @db sysname;

DECLARE db_cur CURSOR LOCAL FAST_FORWARD FOR
    SELECT DbName FROM @DBs;

OPEN db_cur;
FETCH NEXT FROM db_cur INTO @db;

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        DECLARE @sql nvarchar(max) = N''
USE '' + QUOTENAME(@db) + N'';
REVOKE DELETE ON SCHEMA::'' + QUOTENAME(@SchemaName) + N'' FROM '' + QUOTENAME(@Principal) + N'';
'';
        EXEC sp_executesql @sql;

        INSERT dba_db.dbo.Log_Privilegios_Prevencao
            (Action, LoginCaller, PrincipalName, DatabaseName, PermissionName, ScopeType, ScopeName, ExpiresAt, RequestedBy, JobName, Info)
        VALUES
            (''REVOKE'', @LoginCaller, @Principal, @db, ''DELETE'', ''SCHEMA'', @SchemaName, @ExpiresAt, SUSER_SNAME(), @JobName, N''REVOKE DELETE ON SCHEMA'');
    END TRY
    BEGIN CATCH
        INSERT dba_db.dbo.Log_Privilegios_Prevencao
            (Action, LoginCaller, PrincipalName, DatabaseName, PermissionName, ScopeType, ScopeName, ExpiresAt, RequestedBy, JobName, Info)
        VALUES
            (''ERROR_REVOKE'', @LoginCaller, @Principal, @db, ''DELETE'', ''SCHEMA'', @SchemaName, @ExpiresAt, SUSER_SNAME(), @JobName,
             CONCAT(N''Error '', ERROR_NUMBER(), N'' (line '', ERROR_LINE(), N''): '', ERROR_MESSAGE()));
    END CATCH;

    FETCH NEXT FROM db_cur INTO @db;
END

CLOSE db_cur;
DEALLOCATE db_cur;
';

        DECLARE @JobCmd_Delete nvarchar(max) =
N'
BEGIN TRY
    DECLARE @LoginCaller varchar(20) = N''' + REPLACE(@LoginCaller,'''','''''') + N''';
    DECLARE @JobName sysname = N''' + REPLACE(@JobName,'''','''''') + N''';

    INSERT dba_db.dbo.Log_Privilegios_Prevencao
        (Action, LoginCaller, PrincipalName, DatabaseName, PermissionName, ScopeType, ScopeName, ExpiresAt, RequestedBy, JobName, Info)
    VALUES
        (''JOB_DELETE'', @LoginCaller, N''' + REPLACE(@Principal,'''','''''') + N''', N''msdb'', N''DELETE'', N''SCHEMA'', N''' + REPLACE(@SchemaName,'''','''''') + N''',
         NULL, SUSER_SNAME(), @JobName, N''Deleting job and unused schedule'');

    EXEC msdb.dbo.sp_delete_job
         @job_name = @JobName,
         @delete_unused_schedule = 1;
END TRY
BEGIN CATCH
    INSERT dba_db.dbo.Log_Privilegios_Prevencao
        (Action, LoginCaller, PrincipalName, DatabaseName, PermissionName, ScopeType, ScopeName, ExpiresAt, RequestedBy, JobName, Info)
    VALUES
        (''ERROR_JOB_DELETE'', N''' + REPLACE(@LoginCaller,'''','''''') + N''', N''' + REPLACE(@Principal,'''','''''') + N''', N''msdb'', N''DELETE'', N''SCHEMA'', N''' + REPLACE(@SchemaName,'''','''''') + N''',
         NULL, SUSER_SNAME(), N''' + REPLACE(@JobName,'''','''''') + N''',
         CONCAT(N''Error '', ERROR_NUMBER(), N'' (line '', ERROR_LINE(), N''): '', ERROR_MESSAGE()));
END CATCH;
';

        /* ============================================================
           3) CRIAR JOB + 2 STEPS + SCHEDULE ONE-TIME
           ============================================================ */
        EXEC msdb.dbo.sp_add_job
             @job_name = @JobName,
             @enabled = 1,
             @description = N'Revoke temp DELETE permission (prevenção) apos 5 minutos faz auto-suspend',
             @category_name = N'[Uncategorized (Local)]';

        -- Step 1: REVOKE
        EXEC msdb.dbo.sp_add_jobstep
             @job_name = @JobName,
             @step_name = N'01 - Revoke temp DELETE',
             @subsystem = N'TSQL',
             @database_name = N'master',
             @command = @JobCmd_Revoke,
             @on_success_action = 3,   -- next step
             @on_fail_action = 3;      -- next step (tenta apagar job mesmo que revoke falhe)

        -- Step 2: Self delete job
        EXEC msdb.dbo.sp_add_jobstep
             @job_name = @JobName,
             @step_name = N'02 - Self delete job',
             @subsystem = N'TSQL',
             @database_name = N'master',
             @command = @JobCmd_Delete,
             @on_success_action = 1,   -- quit success
             @on_fail_action = 2;      -- quit failure

        EXEC msdb.dbo.sp_add_schedule
             @schedule_name = @SchedName,
             @enabled = 1,
             @freq_type = 1,                 -- one time
             @active_start_date = @RunDate,
             @active_start_time = @RunTime;

        EXEC msdb.dbo.sp_attach_schedule
             @job_name = @JobName,
             @schedule_name = @SchedName;

        EXEC msdb.dbo.sp_add_jobserver
             @job_name = @JobName;

        -- NÃO fazer sp_start_job (senão revoga já)

        SELECT
            @LoginCaller AS LoginCaller,
            @Principal   AS Principal,
            @SchemaName  AS ScopeSchema,
            @RunAt       AS ScheduledRunAt,
            @ExpiresAt   AS ExpiresAt,
            @JobName     AS JobName,
            @SchedName   AS ScheduleName;

    END TRY
    BEGIN CATCH
        SELECT
            ERROR_NUMBER()  AS ErrorNumber,
            ERROR_LINE()    AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
