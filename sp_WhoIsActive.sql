USE [dba_db]
GO
DECLARE	@return_value int,
		@schema varchar(max)
EXEC	@return_value = [dbo].[sp_WhoIsActive]
		@schema = @schema OUTPUT
SELECT	@schema as N'@schema'
SELECT	'Return Value' = @return_value
GO