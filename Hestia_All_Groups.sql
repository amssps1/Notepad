use lusiadas
go
select
  [BD] AS [BD]
, [Schema] AS [Schema]
, [Tabela] AS [Tabela]
, [Group] as [Group]
, case
when [Schema] = '' then ''
when [BD] = left([Tabela],len([BD])) then 'GRANT SELECT ON SCHEMA :: ['+[Schema]+']  TO [COFIDIS2000\' + [Group] + ']'
else 'GRANT SELECT ON ['+[Schema]+'].['+[Tabela]+'] TO [COFIDIS2000\' + [Group] + ']'
end
as [SQLQuery]
from (
select [BD], [Schema], [Tabela], [GrpDataAnalytics001], [GrpDataAnalytics002], [GrpDataAnalytics003], [GrpDataAnalytics004], [GrpDataAnalytics005], [GrpDataAnalytics006], [GrpDataAnalytics007], [GrpDataAnalytics008], [GrpDataAnalytics009], [GrpDataAnalytics010], [GrpDataAnalytics011], [GrpDataAnalytics012], [GrpDataAnalytics013], [GrpDataAnalytics014], [GrpDataAnalytics015], [GrpDataAnalytics016], [GrpDataAnalytics017], [GrpDataAnalytics018], [GrpDataAnalytics019], [GrpDataAnalytics020], [GrpDataAnalytics021], [GrpDataAnalytics022], [GrpDataAnalytics023], [GrpDataAnalytics024], [GrpDataAnalytics025], [GrpDataAnalytics026], [GrpDataAnalytics027], [GrpDataAnalytics028], [GrpDataAnalytics029], [GrpDataAnalytics030], [GrpSQLRWDiomedesDOCP], [GrpSQLRWDiomedesDICV]
from dbo.INT_MatrizAcessosTabelas_Base
) pvt
UNPIVOT
( [Qtd] FOR [Group] in ([GrpDataAnalytics001], [GrpDataAnalytics002], [GrpDataAnalytics003], [GrpDataAnalytics004], [GrpDataAnalytics005], [GrpDataAnalytics006], [GrpDataAnalytics007], [GrpDataAnalytics008], [GrpDataAnalytics009], [GrpDataAnalytics010], [GrpDataAnalytics011], [GrpDataAnalytics012], [GrpDataAnalytics013], [GrpDataAnalytics014], [GrpDataAnalytics015], [GrpDataAnalytics016], [GrpDataAnalytics017], [GrpDataAnalytics018], [GrpDataAnalytics019], [GrpDataAnalytics020], [GrpDataAnalytics021], [GrpDataAnalytics022], [GrpDataAnalytics023], [GrpDataAnalytics024], [GrpDataAnalytics025], [GrpDataAnalytics026], [GrpDataAnalytics027], [GrpDataAnalytics028], [GrpDataAnalytics029], [GrpDataAnalytics030], [GrpSQLRWDiomedesDOCP], [GrpSQLRWDiomedesDICV])
) unpvt
WHERE UPPER([Qtd]) = 'X'

AND BD NOT IN ('CRIO')
AND [Group] NOT IN ('GrpSQLRWDiomedesDICV', 'GrpSQLRWDiomedesDOCP')


UNION ALL

SELECT 'DataExperimental_DICV', 'dbo', 'DataExperimental_DICV (all tables)', 'GrpSQLRWDiomedesDICV', 'GRANT SELECT, DROP, UPDATE, DELETE ON SCHEMA :: [dbo] TO [COFIDIS2000\GrpSQLRWDiomedesDICV]'

UNION ALL

SELECT 'DataExperimental_DOCP', 'dbo', 'DataExperimental_DOCP (all tables)', 'GrpSQLRWDiomedesDOCP', 'GRANT SELECT, DROP, UPDATE, DELETE ON SCHEMA :: [dbo] TO [COFIDIS2000\GrpSQLRWDiomedesDOCP]'

order by 1,2,3