USE [master]
GO
ALTER DATABASE [Comunicacoes] ADD FILEGROUP [Secondary]
GO
USE [master]
GO
ALTER DATABASE [Comunicacoes] ADD FILE ( NAME = N'Secondary_fg', FILENAME =
N'S:\data1_fg\comunicacoes_2.ndf' , SIZE = 512000KB , FILEGROWTH = 102400KB ) TO FILEGROUP [Secondary]
GO

/*
use [Comunicacoes]
go
select 
a.Name as 'File group Name', type_desc as 'Filegroup Type', case when is_default=1 then 'Yes' else 'No' end as 'Is filegroup default?',
b.filename as 'File Location',
b.name 'Logical Name',
Convert(numeric(10,3),Convert(numeric(10,3),(size/128))/1024) as 'File Size in MB'
 from sys.filegroups a inner join sys.sysfiles b on a.data_space_id=b.groupid

 */

USE [Comunicacoes]
GO
Create Unique Clustered index [PK_ComunicacaoAutomatica] ON ComunicacaoAutomatica (IdComunicacaoAutomatica asc)  WITH (DROP_EXISTING=ON) ON [Secondary]
GO

sp_updatestats


USE [Comunicacoes]
GO
Create Unique Clustered index PK_ComunicacaoProcessada ON ComunicacaoProcessada (IdComunicacaoProcessada asc)  WITH (DROP_EXISTING=ON) ON [Secondary]
GO

CREATE UNIQUE CLUSTERED INDEX PK_ComunicacaoProcessada
ON dbo.ComunicacaoProcessada ( [IdComunicacaoProcessada] ASC )
WITH (ONLINE = ON, DROP_EXISTING = ON)
ON [secondary]



SELECT MAX([IdComunicacaoProcessada])
FROM dbo.ComunicacaoProcessada

GO


CREATE PARTITION FUNCTION pf_ComunicacaoProcessada (BIGINT)
AS RANGE RIGHT FOR VALUES (49283469)
GO
 
 CREATE PARTITION SCHEME ps_ComunicacaoProcessada
AS PARTITION pf_ComunicacaoProcessada
TO ( [Secondary], [PRIMARY] )
GO


-- Remove underlying partition configuration
DROP PARTITION SCHEME ps_ComunicacaoProcessada;
DROP PARTITION FUNCTION pf_ComunicacaoProcessada;
GO

SELECT
    OBJECT_NAME(p.object_id) AS table_name,
    p.index_id,
    p.rows,
    au.type_desc AS alloc_unit_type,
    au.used_pages,
    fg.name AS fg_name
FROM
    sys.partitions as p
JOIN
    sys.allocation_units AS au on p.hobt_id = au.container_id
JOIN   
    sys.filegroups AS fg on fg.data_space_id = au.data_space_id
WHERE
    p.object_id = OBJECT_ID('ComunicacaoProcessada')
ORDER BY
    table_name, index_id, alloc_unit_type
	
	
------
