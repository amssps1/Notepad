DM_Risco

USE [DM_Risco]
GO

/****** Object:  Index [fo_dta_index_RSC_DM_SocioProf_32_1949966023__K1D_K8_K9]    Script Date: 02/10/2023 17:15:36 ******/
DROP INDEX [fo_dta_index_RSC_DM_SocioProf_32_1949966023__K1D_K8_K9] ON [dbo].[RSC_DM_SocioProf]
GO

/****** Object:  Index [fo_dta_index_RSC_DM_SocioProf_32_1949966023__K1D_K8_K9]    Script Date: 02/10/2023 17:15:36 ******/
CREATE NONCLUSTERED INDEX [fo_dta_index_RSC_DM_SocioProf_32_1949966023__K1D_K8_K9] ON [dbo].[RSC_DM_SocioProf]
(
	[IdMes] ASC,
	numdossier ASC,
	[IdCliente1] ASC,
	[IdCliente2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO




USE [DM_Risco]
GO

/****** Object:  Index [TESTE_IDX_ILOG_FO_07102016]    Script Date: 02/10/2023 12:50:37 ******/
DROP INDEX [TESTE_IDX_ILOG_FO_07102016] ON [dbo].[RSC_DM_SocioProf]
GO

/****** Object:  Index [TESTE_IDX_ILOG_FO_07102016]    Script Date: 02/10/2023 12:50:37 ******/
CREATE NONCLUSTERED INDEX [TESTE_IDX_ILOG_FO_07102016] ON [dbo].[RSC_DM_SocioProf]
(

	[IdProduto] ASC,
		[IdMes] ASC,
		numdossier ,
	[IdCliente1] ASC,
	[IdCliente2] ASC


) include (idorigem, psa,C1_NumContribuinte,C2_NumContribuinte,DataEstado,DataNovoPedido,DataPedido,idestado,DataPrimeiroFinanciamento,DataPSA,DataUltimoFinanciamento,IdFinDAHT1,IdFinDAHT2) 
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

sp_helpindex RSC_DM_SocioProf
--idmes, idcliente1,idcliente2, idproduto,numdossier







USE [DM_Risco]
GO

/****** Object:  Index [fo_dta_index_RSC_DM_SocioProf_32_1949966023__K8_K9_K16_K22_K1_K2]    Script Date: 02/10/2023 15:30:24 ******/
DROP INDEX [fo_dta_index_RSC_DM_SocioProf_32_1949966023__K8_K9_K16_K22_K1_K2] ON [dbo].[RSC_DM_SocioProf]
GO

/****** Object:  Index [fo_dta_index_RSC_DM_SocioProf_32_1949966023__K8_K9_K16_K22_K1_K2]    Script Date: 02/10/2023 15:30:24 ******/
CREATE NONCLUSTERED INDEX [fo_dta_index_RSC_DM_SocioProf_32_1949966023__K8_K9_K16_K22_K1_K2] ON [dbo].[RSC_DM_SocioProf]
(
	[IdMes] ASC,
	[NumDossier] ASC

	) include (idorigem, psa,C1_NumContribuinte,C2_NumContribuinte,DataEstado,DataNovoPedido,DataPedido,idestado,DataPrimeiroFinanciamento,DataPSA,DataUltimoFinanciamento,IdFinDAHT1,IdFinDAHT2) 
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO




