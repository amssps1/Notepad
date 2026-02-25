use master
go


CREATE RESOURCE POOL LimitedResourcePool
WITH
(MIN_CPU_PERCENT=0,
MAX_CPU_PERCENT=75,
MIN_MEMORY_PERCENT=0,
MAX_MEMORY_PERCENT=75)
GO

CREATE RESOURCE POOL UnlimitedResourcePool
WITH
(MIN_CPU_PERCENT=25,
MAX_CPU_PERCENT=100,
MIN_MEMORY_PERCENT=25,
MAX_MEMORY_PERCENT=100)
GO

CREATE WORKLOAD GROUP LimitedResourceGroup
USING LimitedResourcePool;
GO

CREATE WORKLOAD GROUP UnimitedResourceGroup
USING UnlimitedResourcePool;
GO

CREATE FUNCTION dbo.UDFClassifier()
RETURNS SYSNAME
WITH SCHEMABINDING
AS
BEGIN

	Declare @Login sysname 
	DECLARE @WorkloadGroup AS SYSNAME
	set @Login = SUser_Name()

	if (IS_SRVROLEMEMBER('sysadmin') = 1)  --Server Admins
       SET @WorkloadGroup = 'UnlimitedResourceGroup'
    ELSE
		SET @WorkloadGroup = 'LimitedResourceGroup'   


-- [COFIDIS2000\Grp Controlo Permanente e Conformidade]
-- [COFIDIS2000\Grp Servico Risk Management Read]
-- [COFIDIS2000\grpSQLtoRiskManagement]
-- [COFIDIS2000\Grp Suporte Decisao]
-- [COFIDIS2000\Grp Servico Controlo e Acompanhamentos das Operacoes]
-- [COFIDIS2000\Grp TO SCL]
-- [COFIDIS2000\Grp Sector Operational Inteligence]
-- [COFIDIS2000\Grp TecControloActividadeClientes]
-- [COFIDIS2000\Grp TecOperacionalDR]

	RETURN @WorkloadGroup
END
GO


ALTER RESOURCE GOVERNOR
WITH (CLASSIFIER_FUNCTION=dbo.UDFClassifier);
GO
ALTER RESOURCE GOVERNOR RECONFIGURE
GO


/*
ALTER RESOURCE GOVERNOR DISABLE;
GO

ALTER RESOURCE GOVERNOR WITH (CLASSIFIER_FUNCTION = NULL)
GO
ALTER RESOURCE GOVERNOR DISABLE
GO
DROP FUNCTION dbo.UDFClassifier
GO
DROP WORKLOAD GROUP LimitedResourceGroup
GO
DROP WORKLOAD GROUP UnlimitedResourceGroup
GO
DROP RESOURCE POOL LimitedResourcePool
GO
DROP RESOURCE POOL UnlimitedResourcePool
GO
ALTER RESOURCE GOVERNOR RECONFIGURE
GO

*/


