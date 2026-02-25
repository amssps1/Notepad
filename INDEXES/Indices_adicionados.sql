Index a ser criado Perseu


USE [db_cofidis_dah]
GO
CREATE NONCLUSTERED INDEX [DBA_NCIX_Evento_codtip_ianula]
ON [dbo].[Evento] ([CodTipEvento],[iAnulacao])
INCLUDE ([NumDossier],[IdEvento])
GO


<?query --   Grafana

select count(id) Pendentes
from [tcontroldah].[dbo].[tcd_transaction] as t with(nolock)
inner join [tcontroldah].[dbo].[tcd_errorlog] as e with(nolock)
on(t.id = e.idtransaccao)
where  t.status = 'FA' 
and
t.idmetodo  in (74)
and cast(t.createddate as date) > '20210101'
--and cast(t.createddate as date) <= '20200925'
and e.mensagem like '%The remote server returned an error: (503) Server Unavailable.%'

--?>

SELECT t8.[IdPedido], t8.[TokenDocument], t8.[IDEstado], t8.[IdResposta], t8.[Status] FROM [vw_OCR_PedidosSemResposta] t8 WHERE (t8.[IDEstado] = @ld__1) ORDER BY t8.[IdPedido]


create index ocr_resposta  
idpedido
isresposta
status
USE [IDH]

GO

CREATE NONCLUSTERED INDEX [DBA_NCIX_Ocr_resposta_idp_isr_st] ON [dbo].[OCR_Resposta]
(
	[IdPedido] ASC,
	[IdResposta] ASC,
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO

APIs:

[RUP].[dbo].[API_GET_DadosParceiro]


---------------------------  

-- Dia 29/03/2022

--  Apagar INDEXES

sp_helpindex cof_campanhasdossiers

-- já está

DROP INDEX IX_COF_CampanhasDossiers_111938_FO ON cof_campanhasdossiers
GO
DROP INDEX IX_COF_CampanhasDossiers_164191_FO ON cof_campanhasdossiers
GO
DROP INDEX IDX_IdCampActiv ON cof_campanhasdossiers
GO
DROP INDEX IX_COF_CampanhasDossiers_1975_FO ON cof_campanhasdossiers
go


-- Já está
USE [IDH]
GO
CREATE NONCLUSTERED INDEX [DBA_NCIX_OCR_Pedido_Idestado]
ON [dbo].[OCR_Pedido] ([IdEstado])
INCLUDE ([IdPedido],[TokenDocument])
GO

-----------------

-- Já está
sp_helpindex COF_CampanhasDefinicao

DROP INDEX [NonClusteredIndex-20130111-121021_FO] ON COF_CampanhasDefinicao

---------
-- Já está
USE [IDH]
GO
CREATE NONCLUSTERED INDEX [DBA_NCIX_OTP_ProcessoAssinantes_idp_ide]
ON [dbo].[OTP_ProcessoAssinantes] ([IdProcessoOTP],[IdEstado])
GO






sp_helpindex VG_Tarefas

DROP INDEX IX_VG_Tarefas_67819_FO ON VG_Tarefas
go


USE [IDH]
GO
CREATE NONCLUSTERED INDEX [DBA_NCIX_VG_Tarefas_IdActividade]
ON [dbo].[VG_Tarefas] ([IDActividade])
INCLUDE ([IDEstadoTarefa],[IDEquipaExecutante],[IDUserAtribuido])
GO


---
sp_helpindex OSUSR_0N9_ONGOINGCREDITREQUEST

USE [OutSystems]
GO
CREATE NONCLUSTERED INDEX [DBA_NCIX_OSUSR_0N9_ONGOINGCREDITREQUEST_nump]
ON [dbo].[OSUSR_0N9_ONGOINGCREDITREQUEST] ([NUMPROSPECT])

GO
USE [IDH]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[VG_Tarefas] ([IDEstadoTarefa])
INCLUDE ([IDProcesso],[IDActividade],[IDEquipaExecutante],[DataAgendamento])
GO

VG_GET_ObterFTCarteira


VG_UPD_TimerActualizacaoGeracao
FUNCTION [dbo].[fcVG_GetDataInicioTipoDossierPRA_Lar]

------------  
EOS

-- Actualizar estatisticas e Desfragmentar indexes



USE [db_cofidis_dah]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[Evento] ([iAnulacao])
INCLUDE ([DtEvento],[MntEvento],[UtlModificacao])
GO



--- 
-- Diomedes

USE [Armada]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[DM_IVR_SPR] ([Data])
INCLUDE ([idSkillGroup],[NumeroOrigem],[TeclaMenu1])
GO

---
-- criado
USE [CobrancasDAH]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[Documento] ([Origem],[IdReferenciaPagamento])

GO


?????
CREATE NONCLUSTERED INDEX [ix_Cof_Pps_DtAnul]
ON [dbo].[COF_ProcessoProdutoSuplementar] ([IdProdutoSuplementar],[DataAnulacao])
INCLUDE ([IDProcessoProdutoSuplementar],[IDProcesso],[CreatedDate],[IdProcessoCc]) WITH (ONLINE = ON)
GO 

--- Grandinha ...
USE [FileWatcher]
GO
CREATE NONCLUSTERED INDEX [DBA_NCIX_Log_IdConfiguracao]
ON [dbo].[Log] ([IdConfiguracao])
INCLUDE ([IdLog],[Guid],[Mensagem],[IdExecucao],[IdTipoLog],[CreatedDate],[IdServico])
GO




-- foi adicionado
USE [OutSystems]
GO
CREATE NONCLUSTERED INDEX [DBA_NCIX_OSUSR_0N9_ONGOINGCREDITREQUEST_nump]
ON [dbo].[OSUSR_0N9_ONGOINGCREDITREQUEST] ([NUMPROSPECT]) with (ONLINE=ON, MAXDOP = 4)

GO
sp_helpindex OSUSR_0N9_ONGOINGCREDITREQUEST



-- foi adicionado
USE [LogginApp]

GO

CREATE NONCLUSTERED INDEX [DBA_NCIX_cof_erros_app_createdate_desc] ON [dbo].[COF_Erros_APP]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON, MAXDOP=4,ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO


USE [IDH]
GO
CREATE NONCLUSTERED INDEX [DBA_NCIX_PACPartnerContact_Code_type]
ON [dbo].[PACPartnerContact] ([CodeTypeContact])
INCLUDE ([idPartner])
GO





--DONE

USE [IDH]
GO
CREATE NONCLUSTERED INDEX [DBA_NCIX_COF_CLi_UPROCESSO_Tit_Tip_iActivo]
ON [dbo].[COF_ClienteUProcesso] ([Titular],[TipoInterveniente],[iAtivo])
INCLUDE ([IDCliente],[NumDossier])
GO


--DONE

--
DROP INDEX IDX_NumClassment ON dbo.cof_processo

--DONE

--

DROP INDEX IX_COF_Cliente_40028_FO on COF_Cliente
DROP INDEX IX_COF_Cliente_26869_FO on COF_Cliente
DROP INDEX IX_COF_Cliente_38771_FO on COF_Cliente

--- Por aplicar


USE [TcontrolDAH]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[TCD_Transaction] ([CreatedDate])
INCLUDE ([ID],[NumDossier],[IdMetodo],[Status],[ControledBy],[DataAgendaTransacao])
GO


USE [IDH]
GO

CREATE NONCLUSTERED INDEX [DBA_NCIX_vg_tarefas_createddate] ON [dbo].[VG_Tarefas]
(
	[CreatedDate] DESC,
	[CreatedByUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)


CREATE NONCLUSTERED INDEX [DBA_NCIX_vg_tarefas_createddate] ON [dbo].[VG_Tarefas]
(
	[DataFim] DESC,

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

USE [OutSystems]
GO

CREATE NONCLUSTERED INDEX [DBA_NCIX_OSUSR_1PQ_Proposal_Proposaldate] ON [dbo].[OSUSR_1PQ_PROPOSAL]
(
	[PROPOSALDATE] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO




-- adicionado

USE [IDH]

GO

CREATE NONCLUSTERED INDEX [DBA_NCIX_TG_ActEquipa_IDEEQUIPA_ESTADO] ON [dbo].[TG_ActividadeEquipa]
(
	[IDEquipa] ASC,
	[Estado] ASC
)
INCLUDE([IDActividade]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO

