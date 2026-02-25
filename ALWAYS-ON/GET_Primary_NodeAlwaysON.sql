/*
@primary_server= Select primary_replica From sys.dm_hadr_availability_group_states


SELECT CS.replica_server_name
    FROM sys.availability_groups_cluster AS C
        INNER JOIN sys.dm_hadr_availability_replica_cluster_states AS CS
            ON CS.group_id = C.group_id
        INNER JOIN sys.dm_hadr_availability_replica_states AS RS
            ON RS.replica_id = CS.replica_id
	where role_desc='PRIMARY'


if exists(select is_local, role_desc from sys.dm_hadr_availability_replica_states where role = 1 and role_desc = 'PRIMARY') begin
print 'This server [' + upper(@@servername) + '] is the primary.' end
else
print 'This server [' + upper(@@servername) + '] is NOT the primary.'


PS1:
Import-Module FailoverClusters
Get-ClusterResource -Name "AG" | Where-Object {$_.State -eq "Online"} | Select-Object -ExpandProperty OwnerNode


*/


Para codigo T-SQL : 
FROM [ARTEMIS,1515].[IDH].[dbo].[COF_InstituicoesFinanceiras] CIF
		INNER JOIN [ARTEMIS,1515].[IDH].[dbo].[COF_ProcessoFinanceira] CPF 
			ON (CIF.IDInstituicaoFinanceira = CPF.IDInstituicaoFinanceira)
		INNER JOIN [ARTEMIS,1515].[IDH].[dbo].[COF_Processo] CP
		
		
PAra Ansible : Winrm

Para packages e ficheiros :

\\Perseu\     \\shared_perseu  (
\\Artemis\    \\shared_artemis

DTS:ConnectionString="\\Perseu\AutomatismosDAH$\FicheiroEnvio\BancoPortugal\CartoesPagamento\SYM.0921.SYM.000000000082.PSPPPCN.20230214.000000.csv">

DTS:ConnectionString="\\shared_folder_Artemis\AutomatismosDAH$\...

--------------------------------------- 
## outro exemplo


Param (
[string]$SQLServer="hati,1515",
[string]$User='cofidis2000\tfsrelease',
[string]$Password="tfsreleasee",
[string]$InputFile="C:\CopyDbsDev07\Artemis.sql",
[string]$SourceBackupFiles="R:\*.bak",
[string]$DestinationBackupFiles="\\fenris\m$\Artemis\",
[string]$NetworkDrive="\\10.164.90.2\backupArtemis$"
)

$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("R:", "$NetworkDrive", $false, "$User", "$Password")

copy-item "$SourceBackupFiles" $DestinationBackupFiles -force

net use R: /delete /yes

Invoke-Sqlcmd -ServerInstance $SQLServer -Username sa -Password C0fidis -InputFile $InputFile -Verbose -QueryTimeout 1000

--------------------------------------------------------
## app.config ,  com ips , neste caso o 10.164.1.104  é o Perseu , que irá manter o IP


<?xml version="1.0"?>
<configuration>
  <configSections>
    <section name="dataConfiguration" type="Microsoft.Practices.EnterpriseLibrary.Data.Configuration.DatabaseSettings, Microsoft.Practices.EnterpriseLibrary.Data" />
    <sectionGroup name="applicationSettings" type="System.Configuration.ApplicationSettingsGroup, System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089">
      <section name="Tcontrol2._Test.Properties.Settings" type="System.Configuration.ClientSettingsSection, System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" requirePermission="false" />
    </sectionGroup>
  </configSections>
  <dataConfiguration defaultDatabase="ConnectionStringTControlDAH" />
  <appSettings>
    <add key="ConnectionStringTControlDAH" value="server=artemis;Trusted_Connection=True;database=TControlDAH;Connection Timeout=0;Application Name = TCT" />
    <add key="ConnectionStringTControl" value="server=artemis;Trusted_Connection=True;database=TControl;Connection Timeout=0" />
    <add key="ConnectionStringIDH" value="server=artemis;Trusted_Connection=True;database=IDH;Connection Timeout=0" />
    <add key="ConnectionStringDB_Cofidis_DAH" value="server=10.164.1.104;Trusted_Connection=True;database=db_cofidis_dah;Connection Timeout=0" />
    <add key="ConnectionStringDB_Cofidis_DAH_Interface" value="server=10.164.1.104;Trusted_Connection=True;database=db_cofidis_dah_Interface;Connection Timeout=0" />
    <add key="ConnectionStringInterfacesDah" value="server=10.164.1.104;Trusted_Connection=True;database=InterfacesDAH;Connection Timeout=0" />
    <add key="ConnectionStringFM" value="server=artemis;Trusted_Connection=True;database=FM;Connection Timeout=0" />
    <add key="ControleVersoes" value="server=artemis;Trusted_Connection=True;database=TControlDAH;Connection Timeout=120" />
    <add key="PathInterfaces" value="\\localhost\AutomatismosDAH$\Ficheiros SSIS\U_ControlaInterfaces.dtsx" />
    <add key="WebServiceDoItCreator" value="http://10.164.1.187/webdoitcreator/webservices/DoItCreatorWebService.asmx" />
    <add key="WebService" value="http://10.164.1.32:4000/" />
    <add key="ClientSettingsProvider.ServiceUri" value="" />
    <add key="ModoConf" value="DB" />
  </appSettings>
  <runtime>
  
  
  ---------------------
 
 ## outro exemplo com o Artemis , 10.164.1.204, mas este já não deve ser utilizado
 
 <appSettings>

  <!-- Connection String for SQL Server 2000/2005 - kept for backwards compatability - legacy modules-->
  <add key="SiteSqlServer" value="Server=10.164.1.204,1515;Database=DotNetNuke;uid=sa;pwd=dragonballZ;" />  
  <add key="DotNetnuke" value="Server=10.164.1.204,1515;Database=DotNetNuke;uid=sa;pwd=dragonballZ;" />  
  <add key="InstallTemplate" value="DotNetNuke.install.config" />
  <add key="AutoUpgrade" value="false" />
  <add key="UseInstallWizard" value="true" />
  <add key="InstallMemberRole" value="true" />
  <add key="ShowMissingKeys" value="false" />
  <add key="EnableWebFarmSupport" value="false" />
  <add key="EnableCachePersistence" value="false" />
  <add key="HostHeader" value="" />
  <!-- Host Header to remove from URL so "www.mydomain.com/johndoe/Default.aspx" is treated as "www.mydomain.com/Default.aspx" -->
  <add key="RemoveAngleBrackets" value="false" />
  <!--optionally strip angle brackets on public login and registration screens-->
  <add key="PersistentCookieTimeout" value="0" />
  <!--use as persistent cookie expiration. Value is in minutes, and only active if a non-zero figure-->
  <!-- set UsePortNumber to true to preserve the port number if you're using a port number other than 80 (the standard) -->
  <add key="UsePortNumber" value="true" />


  <!-- Valor que somos -->
  <add key="VQS" value="\\baco\intranet$\"/>
  <add key="VQS_http" value="http://apolo:2020/"/>

  <!-- COFIDIS KEYS -->
  <add key="VG_HBConnectionString" value="Server=10.164.1.204,1515;Database=IDH;uid=sa;pwd=dragonballZ;" />
  <add key="cnnFilasTrabalho" value="Server=10.164.1.204,1515;Database=IDH;uid=sa;pwd=dragonballZ;" /> 
  
  
  -----------------------
  
## Upload Path 
  
  custom.appSettings.config
  
    <add key="UploadPath" value="\\perseu\x$\" />
	
---------------

#DTSX - Artemis

U_DB_EnvioMSO.dtsx


----------------

# Servidor de Origem:

dbo.ADM_MigraDossier_IDH.proc.sql



##

o WinRM (Windows Remote Management) pode funcionar com Always On Availability Groups (AGs) e Windows Server Failover Clusters (WSFCs)

Ao usar o WinRM para gerenciar servidores em um AG ou WSFC, você deve direcionar o nome da rede virtual (VNN) do cluster ou o nome do Listener do AG em vez dos nomes individuais dos servidores. Isso permite que você se conecte ao réplica primária ou ao nó ativo do cluster, independentemente do servidor que estiver hospedando-o atualmente.

Eis algumas etapas que você pode seguir para configurar o WinRM para uso com AGs ou WSFCs:

    Configure o WinRM em cada servidor no cluster ou AG. Isso inclui habilitar o serviço WinRM, configurar os Listeners do WinRM e configurar as regras de firewall necessárias.
    Configure o Listener do AG ou o VNN do cluster para permitir conexões WinRM . 
    Use o nome do Listener do AG ou o VNN do cluster como alvo para comandos do WinRM. Ex: 
	
	Enter-PSSession -ComputerName "artemis.cofidis.pt" -Credential (Get-Credential)
	
	
	
	
- FILEWATCHER  (Configuração)
select * from Configuracao
select * from OpcaoParam 
-- update às duas tabelas

PAIOL
-- update a uma tabela -- PAL_Configuracao 


PELEU - DTSXs não vimos Shared para Artmnis/Perseu 
CECROPE - DTSXs não vimos Shared para Artemis/Perseu , só existe shared para \\CURETES
 
- Hestia
ReportesBDP

select * from COF_Interfaces
Só Hestia


 


--------------
AS faz PDS, estava em cima da mesa ser implementado AlwaysOn apenas em PROD, foram levantados alertas e questões sobre esta abordagem uma vez que existiram diferenças e impactos em processos existentes, como por exemplo releases de SQL.
JS questiona:
Quais são as dependências e de quem são
Qual o playbook e plano de rollout
Identificados impactos do golive (downtimes)
Riscos e mitigações