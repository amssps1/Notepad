

Browse all - Learn | Microsoft Docs
Browse all - Learn | Microsoft Docs
Optimize query performance in SQL Server - Learn | Microsoft Docs



Perseu

Tabela
 Saldo
movimento
evento
dossier

Sugestão:

Perseu



-- Done
USE [IDH]
GO
CREATE NONCLUSTERED INDEX DBA_NCIX_Cof_Ped_Doc_Original_id_pedido
ON [dbo].[COF_Pedido_DocumentacaoOriginal] ([IDPedido])
INCLUDE ([Active])
GO

USE [db_cofidis_dah]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[DossierInfo] ([Atributo])
INCLUDE ([NumDossier])
GO


USE [Interfacesdah]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[COF_U_ComAutomatica] ([REF],[iEnvio],[DtProcessamento])
INCLUDE ([NumDossier])
GO


USE [db_cofidis_dah]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[Prestacao] ([iPago],[NumDossier])
GO


USE [db_cofidis_dah]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[Saldo] ([NumDossierAgregador])
INCLUDE ([NumDossier],[TipSaldo],[Montante])
GO



USE [db_cofidis_dah_interface_aux]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[Movimento] ([MntMovimento],[UtlCriacao])
INCLUDE ([NumDossier],[IdEvento],[IdMovimento],[DtMovimento],[CodMovimento],[MntIncidencia],[IdMovimentoRelacionado],[IdImposto])
GO

-- The Query Processor estimates that implementing the following index could improve the query cost by 8.9203%

USE [db_cofidis_dah_interface_aux]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[Evento] ([iAnulacao])
INCLUDE ([NumDossier],[IdEvento],[CodTipEvento],[IdParceiro])
GO


--  executadoem  26/04  - Artemis



drop index IX_Pagamento_501_FO on Pagamento

drop index IDX_1261 on Pagamento


USE [CobrancasDAH]
GO
CREATE NONCLUSTERED INDEX NCIX_CobrancaDAH_Valor1
ON [dbo].[Pagamento] ([Valor])
INCLUDE ([Id_Pagamento],[Id_Documento],[DataMigracao],[DataAlteracao])
GO



drop index IX_COF_ContactoTelefonico_592 on COF_ContactoTelefonico
go

USE [IDH]
GO
CREATE NONCLUSTERED INDEX NCIX_Cof_ContactTel_idClassificacao_activo
ON [dbo].[COF_ContactoTelefonico] ([IDClassificacao],[Active])
INCLUDE ([IDCliente],[Numero],[CreatedDate])
GO


uatfeedback360


-- para aplicar

USE [TcontrolDAH]

GO

SET ANSI_PADDING ON


GO

CREATE NONCLUSTERED INDEX [DBA_NCIX_TCD_Transaction_Id_status] ON [dbo].[TCD_Transaction]
(
	[ID] ASC,
	[Status] ASC
)
INCLUDE([UpdatedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO






