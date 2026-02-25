

use [master]
go
create resource pool lowpriority_pool;
create workload group lowpriority_pool_group using lowpriority_pool;
--create login my_bad_user with password='Plz_Halp_Me_StackExchange';
--go
create or alter function dbo.GetResourceGroup()
returns sysname
with schemabinding
as
begin;
    declare @rg sysname = 'default';
	IF(SUSER_NAME() = 'laizylogin')
		SET @rg = 'lowpriority_pool_group';
    if original_login() = 'laizylogin' set @rg = 'lowpriority_pool_group';
   -- if host_name() = 'cofptddbacademy\mssqlserver' set @rg = 'lowpriority_pool_group';
   -- if program_name() = 'My Custom Data Science App' set @rg = 'demo_group';
    return @rg;
end;
go



alter resource pool lowpriority_pool with (
     max_cpu_percent		= 1,
     cap_cpu_percent		= 1,
	 MIN_MEMORY_PERCENT		= 0,
	 MAX_MEMORY_PERCENT		= 1,
	 MAX_IOPS_PER_VOLUME	= 50,
     MIN_IOPS_PER_VOLUME	= 1
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
drop function if exists dbo.GetResourceGroup;
go