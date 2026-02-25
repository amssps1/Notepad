EXEC dbo.usp_AdaptiveIndexDefrag	
 @Exec_Print = 0
, @printCmds = 1
, @updateStats = 1
, @updateStatsWhere = 1
, @debugMode = 1
, @outputResults = 1

, @dbScope = 'IDH'
	--, @tblName ='dbo.COF_Cliente'
, @forceRescan = 1
, @maxDopRestriction = 4	
, @minPageCount = 8	
, @maxPageCount = NULL	
, @minFragmentation = 2
, @rebuildThreshold = 30	
, @rebuildThreshold_cs = 30	
, @defragDelay = '00:00:01'	
, @defragOrderColumn = 'range_scan_count'
, @dealMaxPartition = NULL	
, @disableNCIX = 0	
, @offlinelocktimeout = 180	
, @onlineRebuild = 1
,@timeLimit = 120