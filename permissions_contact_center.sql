

USE [master]
GO
DECLARE @Prefix NVARCHAR(100) = 'COFIDIS2000\GrpDataAnalytics0'; -- Prefix for the logins

DECLARE @LoginName NVARCHAR(100);
DECLARE @SQL NVARCHAR(MAX);
DECLARE @SQL_DROP NVARCHAR(MAX);

DECLARE @AUX_INT INT=1;

WHILE @AUX_INT <= 30
BEGIN
    -- Construct the login name

	
	IF @AUX_INT < 10
	 
	       SET @LoginName = @Prefix + '0' + CAST(@AUX_INT AS NVARCHAR(10));


	ELSE
	   begin 
		   IF @AUX_INT >= 10 and @AUX_INT < 20
		       SET @LoginName = @Prefix + CAST(@AUX_INT AS NVARCHAR(10));
  
		   ELSE
			  IF @AUX_INT >= 20 and @AUX_INT <= 30
			     SET @LoginName = @Prefix +  CAST(@AUX_INT AS NVARCHAR(10));
   
	   end

	   SET @SQL_DROP = N'IF EXISTS (SELECT * FROM sys.server_principals WHERE name = [' + @LoginName + '] ) ' +
                           N'DROP LOGIN  [' +@LoginName + '] ;';
             
    --   PRINT @SQL_DROP
    ---- Execute the dynamic SQL
      EXEC sp_executesql @SQL_DROP;

        -- Execute the dynamic SQL in the context of the current database
    -- Construct dynamic SQL to create the login
    SET @SQL = N'CREATE LOGIN [' + @LoginName + '] ' + 
              N'FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english];';

    SET @AUX_INT = @AUX_INT + 1;          
    PRINT @SQL 
    -- Execute the dynamic SQL
    EXEC sp_executesql @SQL;
	-- Vriar o User nas BDs
	EXEC dba_db.dbo.sp_DBA_CreateDBUser @LoginName_var = @LoginName;

    -- Increment the counter
   
END;


