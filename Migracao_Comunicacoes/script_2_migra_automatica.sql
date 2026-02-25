/* 7.2 - */

USE comunicacoes

declare @sairLoop bit = 0

while (@sairLoop = 0)
BEGIN

	BEGIN TRANSACTION
    
    SET STATISTICS TIME ON
	SET IDENTITY_INSERT ComunicacaoAutomatica ON

	SELECT DISTINCT TOP 100000 ca.IdComAutomatica, ca.IdComunicacaoProcessada, CASE WHEN ca.IdReferenciaComunicacao IS NOT NULL THEN ca.IdReferenciaComunicacao WHEN cp.IdReferenciaComunicacao IS NOT NULL THEN cp.IdReferenciaComunicacao WHEN ref.IdReferenciaComunicacao IS NOT NULL THEN ref.IdReferenciaComunicacao ELSE -1 END AS IdReferenciaComunicacao, 
	ISNULL(a.AplicationId, 1) AS IdAplicacao, ca.IDComExt, IIF(ca.idprocesso IS NOT NULL, ca.idprocesso, p.idprocesso) AS IdProcesso, ca.DtAgendamento, IIF(cup2.IdCliente IS NOT NULL, cup2.IdCliente, cup3.IdCliente) AS IdCliente, 
	CASE WHEN migrado IN(0,1,5,111,11,14,10) THEN 1 WHEN migrado IN(2,6) THEN 2 WHEN migrado IN(1,4) THEN 3 WHEN migrado IN(3,7,12,13,15) THEN 4 ELSE 5 END AS migrado, ISNULL(ca.CreatedByUser, 9) AS CreatedByUser, 
	ca.CreatedDate, ISNULL(ca.CreatedByUser, 9) AS UpdatedUser, ca.UpdatedDate
	INTO #temp 
	FROM idh.dbo.com_comunicacaoautomatica ca
	LEFT JOIN idh.dbo.cof_processo p ON p.numdossier = ca.numdossier
	LEFT JOIN idh.dbo.com_comunicacaoProcessada cp ON cp.Id = ca.IdComunicacaoProcessada
	LEFT JOIN idh.dbo.com_referenciacomunicacao ref ON LTRIM(RTRIM(ref.ReferenciaEXT)) LIKE'%'+CONCAT('#', LTRIM(RTRIM(ca.ReferenciaEXT)), '#')+'%'
	LEFT JOIN idh.dbo.COM_aplication a ON a.AplicationId = ca.IdAplicacao
	OUTER APPLY(SELECT TOP 1 cup2.idCliente
				FROM idh.dbo.cof_clienteUProcesso cup2 
				WHERE cup2.IDProcesso = ISNULL(ca.IdProcesso, p.IdProcesso) AND cup2.Ordem = ca.Titular
				ORDER BY cup2.iAtivo DESC) cup2
	OUTER APPLY(SELECT TOP 1 cup3.idCliente
				FROM idh.dbo.cof_clienteUProcesso cup3 
				WHERE cup3.IDProcesso = ISNULL(ca.IdProcesso, p.IdProcesso) AND cup3.Ordem = 1
				ORDER BY cup3.iAtivo DESC) cup3
	WHERE CASE WHEN ca.IdReferenciaComunicacao IS NOT NULL THEN ca.IdReferenciaComunicacao WHEN cp.IdReferenciaComunicacao IS NOT NULL THEN cp.IdReferenciaComunicacao WHEN ref.IdReferenciaComunicacao IS NOT NULL THEN ref.IdReferenciaComunicacao ELSE -1 END <> -1
	AND IIF(cup2.IdCliente IS NOT NULL, cup2.IdCliente, cup3.IdCliente) IS NOT NULL
	AND NOT EXISTS(SELECT 1 FROM ComunicacaoAutomatica ca1 WHERE ca1.IdComunicacaoAutomatica = ca.IdComAutomatica)
	AND EXISTS(SELECT 1 FROM ComunicacaoProcessada cp1 WHERE cp1.IdComunicacaoProcessada = ca.IdComunicacaoProcessada)
	ORDER BY ca.CreatedDate ASC
	
	INSERT INTO ComunicacaoAutomatica (IdComunicacaoAutomatica, IdComunicacaoProcessada, IdReferenciaComunicacao, IdAplicacao, IdComExt, IdProcesso, DataAgendamento, IdCliente, IdEstadoComunicacaoAutomatica, CreatedByUser, CreatedDate, UpdatedByUser, UpdatedDate) 
	SELECT IdComAutomatica, IdComunicacaoProcessada, IdReferenciaComunicacao, IdAplicacao, IDComExt, IdProcesso, DtAgendamento, IdCliente, migrado, CreatedByUser, CreatedDate, UpdatedUser, UpdatedDate
	FROM #temp

	IF EXISTS(SELECT TOP 1 1 FROM #temp)
		SET @sairLoop = 0
	ELSE 
		SET @sairLoop = 1
	
	DROP TABLE #temp

	SET IDENTITY_INSERT ComunicacaoAutomatica OFF
	
    SET STATISTICS TIME OFF
	COMMIT
END













