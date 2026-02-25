

IF OBJECT_ID('tempdb.dbo.#tab_cruzamento','U') is not null drop table #tab_cruzamento;

select 
    iddia_contacto, contacto_15d, 
    b.iddia_pedido, b.iddia_financiamento, contact_type, a.idcliente, a.nif, b.numdossier, b.tipofinanciamento, b.mntfinanciado, b.iduser_pedido, bb.iduser_fin, 
    DATEDIFF(day,iddia_contacto, b.iddia_pedido) as DiasAtéPedido,
    DATEDIFF(day,iddia_contacto, bb.iddia_financiamento) as DiasAtéFinanciamento,
    case when b.iddia_pedido is not null then 1 else 0 
        end iPedidoForaAb,
    case when bb.iddia_financiamento is not null then 1 else 0 
        end iFinanciamentoForaAb,
    ROW_NUMBER() OVER (PARTITION BY iddia_contacto, contact_type, a.idcliente Order by iddia_contacto) as rn_ncontactos,
    d.iDossierInativo, d.CodProdAlfa, 
    case when d.CodProdAlfa = 'RUC' then 'RUC' else 'RGA' 
    end GamaProduto, 
    left(d.DtAbertura,6) as AnoAbertura, d.MntDisponivel, d.Plafond,
    case when d.NumMesesInatividade = -1 then '0. Ativo'
               when d.NumMesesInatividade between 0 and 3 then '1.Inativo há 3M'
               when d.NumMesesInatividade between 3 and 9 then '2.Inativo há 3M a 9m'
               when d.NumMesesInatividade between 9 and 12 then '3.Inativo há 9M a 12m'
               when d.NumMesesInatividade between 12 and 24 then '4.Inativo há 12M a 24m'
               when d.NumMesesInatividade between 24 and 36 then '5.Inativo há 24M a 36m'              
               when d.NumMesesInatividade between 36 and 48  then '6. Entre 36-48 meses'
               when d.NumMesesInatividade between 48 and 84  then '7. Entre 48-84 meses'
               when d.NumMesesInatividade >  84 then '8. Mais de 84 meses'
        end as Classe_atividade
into #tab_cruzamento
from #contactos_final a 
left join #tab_financiamentos b on a.idcliente=b.IdCliente and b.iddia_pedido between a.iddia_contacto and a.contacto_15d -- contactos 531180 -> 142776 NIF
left join #tab_financiamentos bb on a.idcliente=bb.IdCliente and bb.iddia_financiamento between a.iddia_contacto and a.contacto_15d 
left join armada.dbo.DM_ClienteProcesso c on a.nif=c.NIF
left join armada.dbo.DAH_BaseRisco_Historico d on c.NumDossier=d.NumDossier and a.idmes_contacto=d.Idmes
where a.idcliente is not null