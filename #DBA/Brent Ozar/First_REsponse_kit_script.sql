
use dba_db
go
/*Check only the priority id up to 50*/
exec sp_Blitz @IgnorePrioritiesAbove = 50

--
exec sp_BlitzCache

exec SP_BlitzFirst 

exec dba_db.dbo.sp_BlitzIndex @GetAllDatabases = 1, @bringthepain=1 -- It will give the missing indexes and unused indexes