# Teste de pull

WITH DossieEventos AS (
    SELECT
        p.F27086 AS cpf,
        p.F00091 AS nome,
        ev.F09582 AS data_andamento,
        n.F09562 AS andamento,
        CASE
            WHEN n.F09562 = 'Acordo cancelado' THEN 'Cancelado'
            WHEN n.F09562 IN ('Acordo a vista', 'Acordo com entrada', 'Acordo sem entrada', 'Acordo formalizado e pago') THEN 'Formalizado'
            WHEN n.F09562 IN ('Acordo em formalização', 'Acordo aguardando aprovação') THEN 'Não formalizado'
            ELSE NULL
        END AS status_cobranca,
        dv.F00213 AS divisao_nome,
        ROW_NUMBER() OVER (PARTITION BY p.F27086 ORDER BY ev.F09582 DESC) AS rn,
        ue.F00210 AS uniddade,
        ge.F09675 AS empresa_cliente,
        ec.F26297 AS carteira
    FROM [ramaprod].[dbo].T00930 AS ev
    LEFT JOIN [ramaprod].[dbo].T00927 AS n ON ev.F13752 = n.ID
    LEFT JOIN [ramaprod].[dbo].T01166 AS cb ON ev.F13753 = cb.ID
    LEFT JOIN [ramaprod].[dbo].T00030 AS p ON cb.F27938 = p.ID
    LEFT JOIN [ramaprod].[dbo].T00045 AS dv ON cb.F31050 = dv.ID
    LEFT JOIN [ramaprod].[dbo].T00044 AS ue ON cb.F31049 = ue.ID
    LEFT JOIN [ramaprod].[dbo].T01860 AS cbe ON cb.F26457 = cbe.ID
    LEFT JOIN [ramaprod].[dbo].T00938 AS ge ON cbe.F26314 = ge.ID
    LEFT JOIN [ramaprod].[dbo].T01859 AS ec ON cb.F26458 = ec.ID
    WHERE 
        ev.F09582 >= DATEADD(YEAR, -5, GETDATE()) AND 
        n.F09562 IN ('Acordo a vista', 'Acordo com entrada', 'Acordo sem entrada', 'Acordo formalizado e pago', 'Acordo em formalização', 'Acordo aguardando aprovação', 'Acordo cancelado', 'Entrada paga')
),
ConteciosoEventos AS (
    SELECT
        f.F14474 AS dossie,
        m.F01130 AS carteira,
        n.F27086 AS cpf_cnpj,
        a.F00385 AS data_evento,
        j.F01132 AS evento,
        CASE
            WHEN j.F01132 = 'Acordo - Negociação (Principal)' THEN 'Não formalizado'
            WHEN j.F01132 = 'Acordo - Termo Enviado para Protocolo' THEN 'Formalizado'
            WHEN  j.F01132 = 'Acordo cancelado' THEN 'Cancelado'
            ELSE NULL
        END AS status_ce,
        ROW_NUMBER() OVER (PARTITION BY f.F14474, n.F27086 ORDER BY a.F00385 DESC) AS rn
    FROM [ramaprod].[dbo].T00069 AS a
    LEFT JOIN [ramaprod].[dbo].T00064 AS j ON a.F01133 = j.ID
    LEFT JOIN [ramaprod].[dbo].T00041 AS f ON a.F02003 = f.ID
    LEFT JOIN [ramaprod].[dbo].T00035 AS m ON f.F01187 = m.ID
    LEFT JOIN [ramaprod].[dbo].T00030 AS n ON f.F05220 = n.ID
    WHERE 
        a.F00385 >= DATEADD(YEAR, -5, GETDATE()) AND 
        j.F01132 IN ('Acordo - Negociação (Principal)','Acordo - Termo Enviado para Protocolo', 'Acordo cancelado')
),
consulta AS 
(
SELECT
    de.cpf AS cpf,
    de.nome AS nome,
    de.data_andamento,
    de.carteira AS carteira_cob,
    de.andamento as anda,
    ce.dossie AS dossie,
    ce.carteira AS carteira_2,
    de.divisao_nome AS divisao,
    ce.data_evento,
    ce.evento as event,
    ce.rn AS rn1,
    de.rn AS rn2,
    CASE
        WHEN ce.dossie IS NOT NULL THEN 'Processual'
        WHEN ce.dossie IS NULL THEN 'IPCD'
        ELSE 'IPCD'
    END AS tipo_acordo,
    CASE 
        WHEN ce.dossie IS NOT NULL THEN ce.data_evento
        ELSE de.data_andamento
    END AS data_unificada
FROM DossieEventos AS de
FULL OUTER JOIN ConteciosoEventos AS ce ON de.cpf = ce.cpf_cnpj
),
consulta2 AS (
SELECT
    nome as nm,
    cpf AS cpf2,
    dossie AS doss,
    MAX(carteira_2) AS carteira_varejo,
    MAX(carteira_cob) AS carteira_cob_2,
    MAX(divisao) AS div_nome,
    MAX(data_unificada) AS dt_uini,
    MAX(tipo_acordo) AS tp_acordo,
    MAX(anda) AS andamento2,
    MAX(event) AS evento2
FROM consulta
GROUP BY nome, cpf, dossie
HAVING MAX(rn1) = 1 OR MAX(rn2) = 1
)
SELECT
    nm,
    cpf2,
    doss,
    CASE
        WHEN tp_acordo = 'IPCD' THEN (CASE 
                                        WHEN carteira_cob_2 IN ('Massificado PJ', 'Massificado PF', 'Alto Ticket', 'Autos') THEN 'Varejo'
                                        WHEN carteira_cob_2 IN ('Agro', 'AGRO', '') THEN 'Agro' 
                                        WHEN carteira_cob_2 IN ('Judicial Especializado', 'Créditos Especiais E2', 'Créditos Especiais E3') THEN 'E3'
                                        WHEN carteira_cob_2 IN ('Recuperação Judicial - Empresas 1 e 2', 'Recuperação Judicial', 'Falência - Empresas 1 e 2', 'Recuperação Judicial - Empresas 3',
                                            'Falência', 'Recuperação Judicial - Créditos Especiais E2', 'Falência - Empresas 3', 'Recuperação Judicial - Produtor Rural') THEN 'Falência e RJ'
                                        ELSE 'Outro'
                                    END)
        WHEN tp_acordo = 'Processual' THEN (CASE 
                                                WHEN carteira_varejo IN ('E1', 'Massificado PJ', 'PF', 'Massificado PJ - E2', 'E2', 'Autos Santander', 'Alto Ticket', 'Massificado PJ','Diligência Varejo Massificado') THEN 'Varejo' 
                                                WHEN carteira_varejo IN ('Empresas 3 - Judicial Especializado', 'Empresas 3 - Núcleo Massificado', 'Créditos Especiais - Special Credit') THEN 'E3'
                                                WHEN carteira_varejo = 'Credito Rural' THEN 'Agro'
                                                WHEN carteira_varejo IN ('Falência', 'Falência - Créditos Especiai', 'Falência - Empresas 1 e 2', 'Falência - Empresas 3', 'Recuperação Judicial', 'Recuperação Judicial - Créditos Especiais',
                                            'Recuperação Judicial - Empresas 1 e 2', 'Recuperação Judicial - Empresas 3', 'Recuperação Judicial - Empresas 1 e 2 Baixo Ticket', 'Recuperação Judicial - Produtor Rural') THEN 'Falência e RJ'
                                                ELSE 'Outro'
                                            END)
        ELSE NULL
    END AS setor,
    dt_uini,
    tp_acordo,
    div_nome,
    CASE
        WHEN tp_acordo = 'IPCD' THEN (CASE 
                                        WHEN andamento2 IN ('Acordo a vista', 'Acordo com entrada', 'Acordo sem entrada', 'Acordo formalizado e pago', 'Entrada paga') THEN 'Formalizado'
                                        WHEN andamento2 IN ('Acordo em formalização', 'Acordo aguardando aprovação') THEN 'Não formalizado' 
                                        WHEN andamento2 = 'Acordo cancelado' THEN 'Cancelado'
                                    END)
        WHEN tp_acordo = 'Processual' THEN (CASE 
                                                WHEN evento2 = 'Acordo - Negociação (Principal)' THEN 'Não formalizado' 
                                                WHEN evento2 = 'Acordo - Termo Enviado para Protocolo' THEN 'Formalizado'
                                                WHEN evento2 = 'Acordo cancelado' THEN 'Cancelado'
                                            END)
        ELSE NULL
    END AS status_acordo
FROM consulta2
ORDER BY dt_uini DESC;
