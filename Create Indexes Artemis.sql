
-- Indeces  a ser criado


USE [TcontrolDAH]
GO
CREATE NONCLUSTERED INDEX [NCIX_dba_TCD_Transaction_Imetodo_Status]
ON [dbo].[TCD_Transaction] ([IdMetodo],[Status])
INCLUDE ([NumDossier],[CreatedDate],[UpdatedDate])  WITH (ONLINE = ON)
ON [INDICE]
GO

sp_helpindex TCD_Transaction


USE [IDH]
GO
CREATE NONCLUSTERED INDEX [NCIX_dba_COF_ContactoTelefonico_IDClassificacao]
ON [dbo].[COF_ContactoTelefonico] ([IDClassificacao],[Active],[Numero])
INCLUDE ([IDCliente])
GO


-- Para aplicar no EOS

USE [db_cofidis_dah]
GO
CREATE NONCLUSTERED INDEX NCIX_DBA_Movimento_CodMovimento
ON [dbo].[Movimento] ([CodMovimento])
INCLUDE ([NumDossier],[IdEvento],[IdMovimento],[DtMovimento],[CodTipMovimento],[MntMovimento],[MntIncidencia],[DtCriacao])
GO



USE [IDH]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[COF_Processo] ([CodProduto],[IDProcesso],[CodEstado])
GO



-- Já adicionado

CREATE NONCLUSTERED INDEX [NCIX_DBA_MovimentoAutorizadoExtrato_Cativo]
ON [dbo].[MovimentoAutorizadoExtrato] ([Cativo])
INCLUDE ([IdMovimentoAutorizado],[NumDossier],[MontanteMoedaOrigem],[CodMoeda],[CodPais],[LocTerm],[IdTransacaoSIBS],[SisOperTipo],[Cambio],[IdCategoriaMcc],[Sinal])
GO


USE [IDH]
GO
CREATE NONCLUSTERED INDEX [NCIX_DBA_COF_DadosH_idcliente_active]
ON [dbo].[COF_DadosHabitacaoHistorico] ([IdCliente],[Active])
GO



alter index all on register rebuild with (ONLINE=ON)


OCR_Resposta



-- 12/4/2022
-- para aplicar

USE IDH
GO
CREATE NONCLUSTERED INDEX [IX_Cof_Processo_NumDossierIdProcesso]
ON [dbo].[COF_Processo] ([NumDossier], [IdProcesso])
WITH (ONLINE=ON, FILLFACTOR=90)
GO 
