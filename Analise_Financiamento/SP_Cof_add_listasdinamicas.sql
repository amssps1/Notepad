USE [IDH]
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[API_ADD_COF_ListasDinamicasDocumentosRendimentos]') AND type in (N'P', N'PC'))
	EXEC ('CREATE PROCEDURE [dbo].[API_ADD_COF_ListasDinamicasDocumentosRendimentos] AS')
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---- =============================================
---- Author: Daniel Basilio
---- Create date: 27-07-2018
---- Updated: 27-03-2019 - Nuno Pinto
---- Description: Realiza as regras listas dinâmicas presentes no ACP Análise e Financiamento v3.0
---- Projecto: Digitalizacao
---- Version: 0.001
---- =============================================
ALTER PROCEDURE [dbo].[API_ADD_COF_ListasDinamicasDocumentosRendimentos]
	@IDProcesso numeric,
	@IDAplicacao numeric, 
	@IDPedidoGrupo numeric = null,
	@Utilizador nvarchar(100)
AS
BEGIN
	BEGIN TRY
	SET NOCOUNT ON;

	IF(@IDAplicacao IN(33,27,6,34))
	BEGIN
		SET @IDAplicacao = (SELECT TOP 1 IDCOMAplication FROM dbo.COF_Aplicacao WITH(NOLOCK) WHERE IDAplicacao=@IDAplicacao )
	END
	
	DECLARE @idParamTipo AS NUMERIC = (SELECT IdParamTipo FROM dbo.COF_ParamTipo WITH(NOLOCK) WHERE CodParamTipo = 'IDH')
	DECLARE @10vSalarioMinNacional AS NUMERIC(18,2) = 10 * CAST(ISNULL((SELECT Valor FROM dbo.COF_Param WITH(NOLOCK) WHERE CodParam = 'SalarioMinNac' AND IdParamTipo = @idParamTipo),635) AS NUMERIC(18,2))

	DECLARE @IDEstadoDescontinuado INT = (SELECT R.IdReferencias 
										  FROM dbo.COF_Referencias R WITH(NOLOCK)
											INNER JOIN dbo.COF_TipoReferencia TR WITH(NOLOCK)ON r.idtiporeferencia=TR.Idtiporeferencia  
									      WHERE TR.codigo='CPE' AND R.codigo='DESC')

	


	DECLARE @KITSIMPLIFICADO INT=NULL
	DECLARE @KITSIMPLIFICADO_VALOR INT=103346
	
	DECLARE @CODESTADO CHAR(1)=NULL

	-- CODIGO PRODUTO DOSSIER
	DECLARE @CODProduto AS VARCHAR(10) = (SELECT CodProduto 
		                                    FROM dbo.COF_Processo WITH(NOLOCK)
											WHERE IDProcesso = @IDProcesso)
	DECLARE @IsProdutoAuto BIT = 0
	
	IF (@CODProduto IN ('CA','LSG','ALD')) 
	BEGIN 
		SET @IsProdutoAuto = 1
	END
   
    SELECT @KITSIMPLIFICADO=IDKit,@CODESTADO=CODESTADO
	FROM dbo.COF_ProcessoParceiros PP WITH(NOLOCK)
	INNER JOIN dbo.COF_Processo P ON PP.IDProcesso=P.IDProcesso
	WHERE P.IDProcesso=@IDProcesso

	DECLARE @Doc_Copia_Ultimo_Vencimento INT = (SELECT IDDocumento 
												 FROM dbo.COF_Documentos WITH(NOLOCK)
												 WHERE Descricao = 'Cópia do Último Recibo de Vencimento' AND Activo = 1)
	
	DECLARE @pedidosDocParaDescontinuar TABLE (idPedido NUMERIC(18,0))

	IF @CODESTADO IN('H','G','L')
	BEGIN	
		-- DOCUMENTOS
		DECLARE @Doc_Comprovativo_Rendimento INT = (SELECT IDDocumento 
		                                            FROM dbo.COF_Documentos WITH(NOLOCK)
												    WHERE Descricao = 'Comprovativo de Rendimento' AND
													Activo=1)

		

		DECLARE @Doc_Copia_Tres_Ultimos_Vencimento INT = (SELECT IDDocumento 
														  FROM dbo.COF_Documentos WITH(NOLOCK)
														  WHERE Descricao = 'Cópia dos Últimos 3 Recibos de Vencimento' AND 
														  Activo = 1)

		DECLARE @Doc_Comprovativo_Pensao INT = (SELECT IDDocumento 
												FROM dbo.COF_Documentos WITH(NOLOCK)
												WHERE Descricao = 'Cópia do Comprovativo de Pensão' AND 
												Activo = 1)

		DECLARE @Doc_IRC_IES INT = (SELECT IDDocumento 
											FROM dbo.COF_Documentos WITH(NOLOCK)
											WHERE Codigo = 'IRC1' AND 
											Activo = 1)

		-- ESTADOS PEDIDOS
		DECLARE @IDEstadoEmFalta INT = (SELECT IdReferencias 
										FROM dbo.COF_Referencias WITH(NOLOCK)
										WHERE Descricao = 'Em Falta' AND 
										Active = 1 AND 
										IdTipoReferencia = (SELECT IdTipoReferencia 
															FROM dbo.COF_TipoReferencia WITH(NOLOCK)
															WHERE Descricao = 'CategoriaPedido')
										)

		DECLARE @IDEstadoConforme INT = (SELECT R.IdReferencias FROM dbo.COF_Referencias R WITH(NOLOCK)
										 INNER JOIN dbo.COF_TipoReferencia TR WITH(NOLOCK)ON r.idtiporeferencia=TR.Idtiporeferencia  
										 WHERE TR.codigo='CPE' AND R.codigo='CCO')

		DECLARE @IDEstadoAutorizadoGerente INT = (SELECT R.IdReferencias FROM dbo.COF_Referencias R WITH(NOLOCK)
										 INNER JOIN dbo.COF_TipoReferencia TR WITH(NOLOCK)ON r.idtiporeferencia=TR.Idtiporeferencia  
										 WHERE TR.codigo='CPE' AND R.codigo='CAG')

		DECLARE @IDEstadoAutorizadoSuperior INT = (SELECT R.IdReferencias FROM dbo.COF_Referencias R WITH(NOLOCK)
										 INNER JOIN dbo.COF_TipoReferencia TR WITH(NOLOCK)ON r.idtiporeferencia=TR.Idtiporeferencia  
										 WHERE TR.codigo='CPE' AND R.codigo='CAS' )

		DECLARE @IDEstadoRemovido INT = (SELECT R.IdReferencias FROM dbo.COF_Referencias R WITH(NOLOCK)
										 INNER JOIN dbo.COF_TipoReferencia TR WITH(NOLOCK) ON r.idtiporeferencia=TR.Idtiporeferencia  
										 WHERE TR.codigo='CPE' AND
										 R.codigo='RMV')
	
		-- Tipo Cliente
		DECLARE @ClienteEmpresarioIndividual INT = (SELECT R.IdReferencias 
													FROM dbo.COF_Referencias R WITH(NOLOCK)
													INNER JOIN dbo.COF_TipoReferencia TR WITH(NOLOCK) ON r.idtiporeferencia=TR.Idtiporeferencia  
													WHERE TR.codigo='TCL' AND
													R.Descricao='Empresário Nome Individual')

		DECLARE @ClienteParticular INT = (SELECT R.IdReferencias 
										  FROM dbo.COF_Referencias R WITH(NOLOCK)
										  INNER JOIN dbo.COF_TipoReferencia TR WITH(NOLOCK) ON r.idtiporeferencia=TR.Idtiporeferencia  
										  WHERE TR.codigo='TCL' AND 
										  R.Descricao='Particular')
	
		-- Sector profissao Cliente
		DECLARE @ClienteTrabalhadorContaPropria INT = (SELECT TOP 1 R.IdReferencias 
													   FROM dbo.COF_Referencias R WITH(NOLOCK)
													   INNER JOIN dbo.COF_TipoReferencia TR WITH(NOLOCK) ON r.idtiporeferencia=TR.Idtiporeferencia  
													   WHERE TR.codigo='SPR' AND 
													   R.Codigo='C')

		DECLARE @ClienteTrabalhadorContaPropriaContrato INT = (SELECT TOP 1 R.IdReferencias 
															   FROM dbo.COF_Referencias R WITH(NOLOCK)
															   INNER JOIN dbo.COF_TipoReferencia TR WITH(NOLOCK) ON r.idtiporeferencia=TR.Idtiporeferencia  
															   WHERE TR.codigo='TCO' AND 
															   R.Codigo='4')


		DECLARE @PedidoAInserir TABLE(
		  IDProcesso numeric(18,0),
		  IDCliente numeric(18,0),
		  IDTipoDocumento int,
		  IDEstado int,
		  iManual bit,
		  IDPedidoGrupo numeric(18,0),
		  CreatedByUser varchar(50),
		  CreatedDate datetime,
		  UpdatedByUser varchar(50),
		  UpdatedDate datetime,
		  UpdatedIDAplicacao int
		)

		DECLARE @IdsDocumentos TABLE(
		  IDDocumento numeric(18,0)
		)

		DECLARE @IdsDocumentosActuais TABLE(
		  IDTipoDocumento numeric(18,0),
		  IDCliente numeric(18,0)
		)

		IF @IDPedidoGrupo IS NULL
		BEGIN		
			INSERT INTO [dbo].[COF_PedidoGrupo] ([CreatedByUser],[CreatedDate]) VALUES(@Utilizador,GETDATE())
			SET @IDPedidoGrupo = (SELECT @@IDENTITY IDPedidoGrupo)
		END

		INSERT INTO @IdsDocumentos (IDDocumento) VALUES (@Doc_Comprovativo_Rendimento)
		INSERT INTO @IdsDocumentos (IDDocumento) VALUES (@Doc_Copia_Ultimo_Vencimento)
		INSERT INTO @IdsDocumentos (IDDocumento) VALUES (@Doc_Copia_Tres_Ultimos_Vencimento)
		INSERT INTO @IdsDocumentos (IDDocumento) VALUES (@Doc_Comprovativo_Pensao)
	
		INSERT INTO @IdsDocumentosActuais (IDTipoDocumento,IDCliente) 
		SELECT IdTipoDocumento,IDCliente FROM dbo.COF_PEDIDO WITH(NOLOCK)
		WHERE IDPROCESSO=@IDProcesso AND iManual=0 and IDEstado<>@IDEstadoDescontinuado

		--PRODUTO É UM AUTO
		IF (@ISProdutoAuto = 1)
		BEGIN
			-- Insert no caso do cliente ser ENI
			INSERT INTO @PedidoAInserir
			SELECT @IDProcesso,CLT_P.IDCliente,@Doc_Comprovativo_Rendimento,@IDEstadoEmFalta,0,@IDPedidoGrupo,9,GETDATE(),9,GETDATE(),@IDAplicacao
			FROM dbo.COF_ClienteUProcesso CLT_P WITH(NOLOCK)
			INNER JOIN dbo.COF_Processo PRO WITH(NOLOCK)ON CLT_P.IDProcesso = PRO.IDProcesso
			INNER JOIN dbo.COF_Cliente CL WITH(NOLOCK) ON CL.IDCliente = CLT_P.IDCliente
			INNER JOIN dbo.COF_ClienteProfissao CP WITH(NOLOCK) ON CP.IDCliente = CLT_P.IDCliente AND CP.Active = 1
			INNER JOIN dbo.COF_Profissao PROF WITH(NOLOCK) ON PROF.IDProfissao = CP.IDProfissao
			WHERE CLT_P.IDProcesso = @IDProcesso AND  CLT_P.iAtivo = 1 AND
			(CL.TipoCliente = (SELECT Codigo 
								FROM dbo.COF_Referencias WITH (NOLOCK)
								WHERE IdReferencias = @ClienteEmpresarioIndividual) 
			OR CL.TipoCliente = (SELECT Codigo
								FROM dbo.COF_Referencias WITH (NOLOCK)
								WHERE IdReferencias = @ClienteParticular) AND PROF.IDSectorProfissao = @ClienteTrabalhadorContaPropria ) AND
			PROF.Descricao NOT IN('Reformados','Estudantes','Domésticas','Desempregados') AND
			CLT_P.iAtivo=1 AND 
			CLT_P.TipoInterveniente <> 'E' AND CLT_P.TipoInterveniente <> 'R' AND 
			(@KITSIMPLIFICADO<>@KITSIMPLIFICADO_VALOR) 

			-- Insert no caso do cliente ser Particular
			INSERT INTO @PedidoAInserir
			SELECT @IDProcesso,CLT_P.IDCliente,DOC.IDDocumento,@IDEstadoEmFalta,0,@IDPedidoGrupo,9,GETDATE(),9,GETDATE(),@IDAplicacao 
			FROM dbo.COF_ClienteUProcesso CLT_P WITH(NOLOCK)
				INNER JOIN dbo.COF_Processo PRO WITH(NOLOCK) ON PRO.IDProcesso = @IDProcesso
				INNER JOIN dbo.COF_ProcessoParceiros PRO_PARC WITH(NOLOCK)  ON PRO_PARC.IDProcesso = @IDProcesso
				INNER JOIN dbo.COF_Cliente CL  WITH(NOLOCK) ON CL.IDCliente = CLT_P.IDCliente
				INNER JOIN dbo.COF_ClienteProfissao CP  WITH(NOLOCK) ON CP.IDCliente = CLT_P.IDCliente  AND CP.Active = 1
				INNER JOIN dbo.COF_Profissao PROF  WITH(NOLOCK) ON PROF.IDProfissao = CP.IDProfissao
				INNER JOIN dbo.COF_Documentos DOC  WITH(NOLOCK) ON DOC.IDDocumento IN (@Doc_Copia_Ultimo_Vencimento,@Doc_Copia_Tres_Ultimos_Vencimento)
			WHERE CLT_P.IDProcesso = @IDProcesso AND  CLT_P.iAtivo = 1 AND
			CL.TipoCliente = (SELECT Codigo
			                  FROM dbo.COF_Referencias WITH(NOLOCK)
							  WHERE IdReferencias = @ClienteParticular) AND	 
			 PROF.IDSectorProfissao <> @ClienteTrabalhadorContaPropria AND
			(@KITSIMPLIFICADO<>@KITSIMPLIFICADO_VALOR AND 
					((DOC.IDDocumento = @Doc_Copia_Ultimo_Vencimento AND PRO.Montante <= @10vSalarioMinNacional) OR --Kit Completo
					(DOC.IDDocumento = @Doc_Copia_Tres_Ultimos_Vencimento AND PRO.Montante > @10vSalarioMinNacional))
			) AND 
			PROF.Descricao NOT IN('Reformados','Estudantes','Domésticas','Desempregados') AND
			CLT_P.iAtivo=1 AND 
			CLT_P.TipoInterveniente <> 'E' AND CLT_P.TipoInterveniente <> 'R'

		END
		ELSE
		BEGIN
			-- Produtos NAUTO -> Tipo Cliente é sempre Particular
			--Insert no caso de Trabalhadores por conta própria
			INSERT INTO @PedidoAInserir
			SELECT @IDProcesso,CLT_P.IDCliente,@Doc_Comprovativo_Rendimento,@IDEstadoEmFalta,0,@IDPedidoGrupo,9,GETDATE(),9,GETDATE(),@IDAplicacao 
			FROM dbo.COF_ClienteUProcesso CLT_P WITH(NOLOCK)
				INNER JOIN dbo.COF_ClienteProfissao CP  WITH(NOLOCK) ON CP.IDCliente = CLT_P.IDCliente AND CP.Active = 1
				INNER JOIN dbo.COF_Profissao PROF WITH(NOLOCK)  ON PROF.IDProfissao = CP.IDProfissao
			WHERE CLT_P.IDProcesso = @IDProcesso AND CLT_P.iAtivo = 1 AND
				(ISNULL(CP.IDSectorProfissao,0) =  @ClienteTrabalhadorContaPropria  OR  ISNULL(CP.IDTipoContrato,0) = @ClienteTrabalhadorContaPropriaContrato) AND
				PROF.Descricao NOT IN('Reformados','Estudantes','Domésticas','Desempregados') AND
				CLT_P.iAtivo=1 AND 
				CLT_P.TipoInterveniente <> 'E' AND CLT_P.TipoInterveniente <> 'R'
			
			--Insert no caso de a profissao não ser Trabalhador por conta própria
			INSERT INTO @PedidoAInserir
			SELECT @IDProcesso,CLT_P.IDCliente,DOC.IDDocumento,@IDEstadoEmFalta,0,@IDPedidoGrupo,9,GETDATE(),9,GETDATE(),@IDAplicacao 
			FROM dbo.COF_ClienteUProcesso CLT_P WITH(NOLOCK)
				INNER JOIN dbo.COF_Processo PRO  WITH(NOLOCK) ON PRO.IDProcesso = @IDProcesso
				INNER JOIN dbo.COF_ProcessoParceiros PRO_PARC  WITH(NOLOCK) ON PRO_PARC.IDProcesso = @IDProcesso
				INNER JOIN dbo.COF_Cliente CL  WITH(NOLOCK) ON CL.IDCliente = CLT_P.IDCliente
				INNER JOIN dbo.COF_ClienteProfissao CP  WITH(NOLOCK) ON CP.IDCliente = CLT_P.IDCliente AND CP.Active = 1
				INNER JOIN dbo.COF_Profissao PROF  WITH(NOLOCK) ON PROF.IDProfissao = CP.IDProfissao
				INNER JOIN dbo.COF_Documentos DOC  WITH(NOLOCK) ON DOC.IDDocumento IN (@Doc_Copia_Ultimo_Vencimento,@Doc_Copia_Tres_Ultimos_Vencimento)
			WHERE CLT_P.IDProcesso = @IDProcesso AND  CLT_P.iAtivo = 1 AND
				(ISNULL(CP.IDSectorProfissao,0) !=  @ClienteTrabalhadorContaPropria  AND  ISNULL(CP.IDTipoContrato,0) != @ClienteTrabalhadorContaPropriaContrato AND PROF.Descricao != 'Reformados'
					AND PROF.IDSectorProfissao != (SELECT IdReferencias FROM dbo.COF_Referencias  WITH(NOLOCK) WHERE Descricao = 'Diversos' AND Codigo = 'D')
				) AND ((@KITSIMPLIFICADO<>@KITSIMPLIFICADO_VALOR AND ((DOC.IDDocumento = @Doc_Copia_Ultimo_Vencimento AND PRO.Montante <= @10vSalarioMinNacional) OR --Kit Completo
				(DOC.IDDocumento = @Doc_Copia_Tres_Ultimos_Vencimento AND PRO.Montante > @10vSalarioMinNacional)))) AND
				CLT_P.iAtivo=1 AND 
				CLT_P.TipoInterveniente <> 'E' AND CLT_P.TipoInterveniente <> 'R'

		END
	
		-- Inserts do comprovativo de pensões caso os clientes sejam Reformados

		INSERT INTO @PedidoAInserir				
		SELECT @IDProcesso,CLT_PROCESSO.IDCliente,@Doc_Comprovativo_Pensao,@IDEstadoEmFalta,0,@IDPedidoGrupo,9,GETDATE(),9,GETDATE(),@IDAplicacao 
		FROM dbo.COF_ClienteUProcesso CLT_PROCESSO WITH(NOLOCK)
			INNER JOIN dbo.COF_ClienteProfissao CLT_PROFISSAO  WITH(NOLOCK) ON CLT_PROFISSAO.IDCliente = CLT_PROCESSO.IDCliente AND Active=1
			INNER JOIN dbo.COF_Profissao PROFISSAO  WITH(NOLOCK) ON PROFISSAO.IDProfissao = CLT_PROFISSAO.IDProfissao
		WHERE IDProcesso = @IDProcesso AND 
			PROFISSAO.Descricao = 'Reformados' AND
			CLT_PROCESSO.iAtivo=1 AND 
			CLT_PROCESSO.TipoInterveniente <> 'E' AND CLT_PROCESSO.TipoInterveniente <> 'R'
		
		-- Descontinuar antigos
		UPDATE C_Ped 
		SET C_Ped.IDestado = @IDEstadoDescontinuado, IDDocumentacao=NULL, -- MULTIDOC - OLD - IDDocumentacao = NULL
		UpdatedDate = GETDATE(), UpdatedByUser = @Utilizador
		OUTPUT inserted.IDPedido INTO @pedidosDocParaDescontinuar(idPedido)
		FROM dbo.COF_Pedido C_Ped WITH(NOLOCK)
			INNER JOIN @PedidoAInserir P_Ins   ON P_Ins.IDCliente = C_Ped.IDCliente
		WHERE C_Ped.IDProcesso = @IDProcesso AND
			P_Ins.IDTipoDocumento !=  C_Ped.IDTipoDocumento AND
			C_Ped.IDTipoDocumento not in(select IDTipoDocumento FROM @PedidoAInserir) AND
			C_Ped.IDTipoDocumento IN (SELECT IDDocumento 
									  FROM @IdsDocumentos) AND 
		C_Ped.iManual=0
	
		--Os clientes que estão reformados, nao pode pedir qualquer comprovativo de rendimentos
		UPDATE C_Ped
		SET IDEstado = @IDEstadoDescontinuado, IDDocumentacao=NULL, -- MULTIDOC - OLD - IDDocumentacao = NULL
		UpdatedDate = GETDATE(), UpdatedByUser = @Utilizador
		OUTPUT inserted.IDPedido INTO @pedidosDocParaDescontinuar(idPedido)
		FROM dbo.COF_Pedido C_Ped WITH(NOLOCK)
		WHERE IDProcesso = IDProcesso AND
		IDTipoDocumento IN (@Doc_Comprovativo_Rendimento,@Doc_Copia_Ultimo_Vencimento,@Doc_Copia_Tres_Ultimos_Vencimento) AND
		IDCliente IN (
			SELECT CLT_P.IDCliente
			FROM dbo.COF_ClienteUProcesso CLT_P WITH(NOLOCK)
			INNER JOIN dbo.COF_ClienteProfissao CP  WITH(NOLOCK) ON (CLT_P.IDCliente = CP.IDCliente AND CP.Active = CLT_P.IAtivo)
			INNER JOIN dbo.COF_Profissao PROF  WITH(NOLOCK) ON PROF.IDProfissao = CP.IDProfissao	
			WHERE IDProcesso = @IDProcesso AND PROF.Descricao = 'Reformados' AND CLT_P.IAtivo = 1) AND 
		C_Ped.iManual=0

		--DESCONTINUAR DOCUMENTOS RENDIMENTOS QUANDO CLIENTE E ESTUDANTE, DOMESTICA OU DESEMPREGADO
		UPDATE COF_Pedido
		SET IDEstado = @IDEstadoDescontinuado, IDDocumentacao=NULL, -- MULTIDOC - OLD - IDDocumentacao = NULL
			UpdatedDate = GETDATE(), UpdatedByUser = @Utilizador
		OUTPUT inserted.IDPedido INTO @pedidosDocParaDescontinuar(idPedido)
		FROM dbo.COF_Pedido C_Ped WITH(NOLOCK)
			INNER JOIN dbo.COF_ClienteUProcesso CLT_P  WITH(NOLOCK) ON C_Ped.IDCliente=CLT_P.IDCliente
			INNER JOIN dbo.COF_ClienteProfissao CP  WITH(NOLOCK) ON CP.IDCliente = CLT_P.IDCliente AND CP.Active = 1
			INNER JOIN dbo.COF_Profissao PROF  WITH(NOLOCK) ON PROF.IDProfissao = CP.IDProfissao
		WHERE CLT_P.IDProcesso = @IDProcesso AND CLT_P.iAtivo = 1 AND
			PROF.Descricao  IN('Estudantes','Domésticas','Desempregados') AND
			C_Ped.IDTipoDocumento IN (SELECT IDDocumento FROM @IdsDocumentos) AND 
			C_Ped.iManual=0

		--DESCONTINUAR DOCUMENTOS RENDIMENTOS QUANDO PASSA A ELEMENTO OU REPRESENTANTE
		UPDATE C_Ped
		SET IDEstado = @IDEstadoDescontinuado, IDDocumentacao=NULL, -- MULTIDOC - OLD - IDDocumentacao = NULL
		UpdatedDate = GETDATE(), UpdatedByUser = @Utilizador
		OUTPUT inserted.IDPedido INTO @pedidosDocParaDescontinuar(idPedido)
		FROM dbo.COF_Pedido C_Ped WITH(NOLOCK)
			INNER JOIN dbo.COF_ClienteUProcesso CLT_P  WITH(NOLOCK) ON C_Ped.IDCliente=CLT_P.IDCliente
			INNER JOIN dbo.COF_ClienteProfissao CP  WITH(NOLOCK) ON CP.IDCliente = CLT_P.IDCliente AND CP.Active = 1
			INNER JOIN dbo.COF_Profissao PROF  WITH(NOLOCK) ON PROF.IDProfissao = CP.IDProfissao
		WHERE CLT_P.IDProcesso = @IDProcesso AND CLT_P.iAtivo = 1 
			AND C_Ped.IDTipoDocumento IN (SELECT IDDocumento FROM @IdsDocumentos)
			AND (CLT_P.TipoInterveniente = 'E' OR CLT_P.TipoInterveniente = 'R')

		--DESCONTINUAR DOCUMENTOS RENDIMENTOS QUANDO PARCEIROS MOTO RETOMAM KIT SIMPLIFICADO
		UPDATE C_Ped
		SET IDEstado = @IDEstadoDescontinuado, IDDocumentacao=NULL, -- MULTIDOC - OLD - IDDocumentacao = NULL
			UpdatedDate = GETDATE(), UpdatedByUser = @Utilizador
		OUTPUT inserted.IDPedido INTO @pedidosDocParaDescontinuar(idPedido)
		FROM dbo.COF_Pedido C_Ped WITH(NOLOCK)
			INNER JOIN dbo.COF_ClienteUProcesso CLT_P  WITH(NOLOCK) ON C_Ped.IDCliente=CLT_P.IDCliente AND C_Ped.IDProcesso = CLT_P.IDProcesso
		WHERE C_Ped.IDProcesso = @IDProcesso AND CLT_P.iAtivo = 1 
			AND C_Ped.IDTipoDocumento IN (SELECT IDDocumento FROM @IdsDocumentos) 
			AND (@IsProdutoAuto = 1 AND @KITSIMPLIFICADO=@KITSIMPLIFICADO_VALOR)
		
		--Adicionar novos Pedidos
		INSERT INTO COF_Pedido ([IDProcesso],[IDCliente],[IDTipoDocumento],[IDEstado],[iManual],[IDPedidoGrupo],[CreatedByUser],[CreatedDate],[UpdatedByUser],[UpdatedDate],[UpdatedIDAplicacao])
		SELECT * FROM @PedidoAInserir PED
		WHERE NOT EXISTS (SELECT * 
						  FROM @IdsDocumentosActuais AUX
						  WHERE PED.IDCliente=AUX.IDCliente AND PED.IDTipoDocumento=AUX.IDTipoDocumento)

	END
	IF @KITSIMPLIFICADO=@KITSIMPLIFICADO_VALOR AND @CODESTADO IN('H','G','L')
	BEGIN
		--DESCONTINUAR DOCUMENTOS RENDIMENTOS QUANDO KIT SIMPLIFICADO
		UPDATE COF_Pedido
		SET IDEstado = @IDEstadoDescontinuado, IDDocumentacao=NULL, -- MULTIDOC - OLD - IDDocumentacao = NULL
			UpdatedDate = GETDATE(), UpdatedByUser = @Utilizador
		OUTPUT inserted.IDPedido INTO @pedidosDocParaDescontinuar(idPedido)
		FROM dbo.COF_Pedido C_Ped WITH(NOLOCK)
			INNER JOIN dbo.COF_IncompletosDocumentosCSA DOCS  WITH(NOLOCK) ON C_Ped.IDTipoDocumento=DOCS.IDDOCUMENTO
			INNER JOIN dbo.COF_ClienteUProcesso CLT_P  WITH(NOLOCK) ON C_Ped.IDCliente=CLT_P.IDCliente
			INNER JOIN dbo.COF_ClienteProfissao CP  WITH(NOLOCK) ON CP.IDCliente = CLT_P.IDCliente AND CP.Active = 1
			INNER JOIN dbo.COF_Profissao PROF  WITH(NOLOCK) ON PROF.IDProfissao = CP.IDProfissao
		WHERE CLT_P.IDProcesso = @IDProcesso AND CLT_P.iAtivo = 1 AND C_Ped.iManual=0 AND
		DOCS.IDRefTema=1499 AND 
		((@IsProdutoAuto = 0 OR DOCS.IDDocumento = @Doc_Copia_Ultimo_Vencimento OR DOCS.IDDocumento = @Doc_Comprovativo_Pensao OR DOCS.IDDocumento = @Doc_Comprovativo_Rendimento) OR
		(@IsProdutoAuto = 1))

		--DESCONTINUAR DOCUMENTO Comprovativo de IRC/IES QUANDO KIT SIMPLIFICADO
		UPDATE COF_Pedido
		SET IDEstado = @IDEstadoDescontinuado, IDDocumentacao=NULL, -- MULTIDOC - OLD - IDDocumentacao = NULL
			UpdatedDate = GETDATE(), UpdatedByUser = @Utilizador
		OUTPUT inserted.IDPedido INTO @pedidosDocParaDescontinuar(idPedido)
		FROM dbo.COF_Pedido C_Ped WITH(NOLOCK)
			INNER JOIN dbo.COF_IncompletosDocumentosCSA DOCS  WITH(NOLOCK) ON C_Ped.IDTipoDocumento=DOCS.IDDOCUMENTO
		WHERE C_Ped.IDProcesso = @IDProcesso AND
		DOCS.IDRefTema=1499 AND DOCS.IDDocumento = @Doc_IRC_IES
	END

	--Descontinua documentos na tabela relacional COF_Pedido_Documentacao
	UPDATE COF_Pedido_Documentacao
	SET Active=0, UpdatedDate=GETDATE(), UpdatedByUser=@Utilizador
	WHERE IDPedido IN (SELECT idPedido FROM @pedidosDocParaDescontinuar)

	END TRY
    BEGIN CATCH 
        DECLARE @ERRO_MESSAGE AS VARCHAR(MAX);
		SELECT @ERRO_MESSAGE=ERROR_MESSAGE();
        INSERT INTO dbo.COF_ERROS_SP VALUES (ERROR_PROCEDURE(),@ERRO_MESSAGE,GETDATE());
        RAISERROR(@ERRO_MESSAGE,16,1);
    END CATCH
END