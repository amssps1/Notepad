



use [master]
go
create resource pool lowpriority_pool;
create workload group lowpriority_pool_group using lowpriority_pool;

--create r alter function dbo.GetResourceGroup()
create function dbo.GetResourceGroup()
returns sysname
with schemabinding
as
begin;
    declare @rg sysname = 'default';
	IF(SUSER_NAME() = 'CDM\RICARDMR')
		SET @rg = 'lowpriority_pool_group';
    if original_login() = 'laizylogin' set @rg = 'lowpriority_pool_group';
   -- if host_name() = 'cofptddbacademy\mssqlserver' set @rg = 'lowpriority_pool_group';
   -- if program_name() = 'My Custom Data Science App' set @rg = 'demo_group';
    return @rg;
end;
go



alter resource pool lowpriority_pool with (
     max_cpu_percent		= 2,
     cap_cpu_percent		= 10,
	 MIN_MEMORY_PERCENT		= 0,
	 MAX_MEMORY_PERCENT		= 2

);
go
alter resource governor with (classifier_function = dbo.GetResourceGroup);
alter resource governor reconfigure;
go




-- Limpar tudo
--
use [master]
go

alter resource governor with (classifier_function = null)
alter resource governor disable;
drop workload group lowpriority_pool_group;
drop resource pool lowpriority_pool;
--drop login my_bad_user;
drop function dbo.GetResourceGroup;
go