--XP_CMDSHELL


declare @prevAdvancedOptions int;
declare @prevXpCmdshell int;

select @prevAdvancedOptions = cast(value_in_use as int) from sys.configurations where name = 'show advanced options';
select @prevXpCmdshell = cast(value_in_use as int) from sys.configurations where name = 'xp_cmdshell';

if (@prevAdvancedOptions = 0)
begin
    exec sp_configure 'show advanced options', 1;
    reconfigure;
end;

if (@prevXpCmdshell = 0)
begin
    exec sp_configure 'xp_cmdshell', 1;
    reconfigure;
end;


--- doing some work here ---


if (@prevXpCmdshell = 0)
begin
    exec sp_configure 'xp_cmdshell', 0;
    reconfigure;
end;

if (@prevAdvancedOptions = 0)
begin
    exec sp_configure 'show advanced options', 0;
    reconfigure;
end;


--

SET TRUSTWORTHY ON

--
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'clr enabled', 1;
GO
RECONFIGURE;
GO

--
-- OU
if not exists(     SELECT value     FROM sys.configurations     WHERE name = 'clr enabled'      and value = 1 ) 
  begin     
      exec sp_configure @configname=clr_enabled, @configvalue=1
	  reconfigure 
  end
