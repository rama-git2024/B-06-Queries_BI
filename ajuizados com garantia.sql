WITH garantias AS (
SELECT
    a.F15674 AS processo,
    c.F14474 AS dossie,
    d.F01130 AS carteira,
    CASE 
    	WHEN c.F25017 = 1 THEN 'Ativo'
    	WHEN c.F25017 = 2 THEN 'Encerrado'
    	WHEN c.F25017 = 3 THEN 'Acordo'
    	WHEN c.F25017 = 6 THEN 'Em encerramento'
    	WHEN c.F25017 = 4 THEN 'Em precatório (Ativo)'
    END AS situacao,
    CASE
        WHEN a.F17000 = 1 THEN 'BacenJUD'
        WHEN a.F17000 = 2 THEN 'Equipamento'
        WHEN a.F17000 = 3 THEN 'Imóvel'
        WHEN a.F17000 = 4 THEN 'Veículo'
        WHEN a.F17000 = 5 THEN 'Outros'
        WHEN a.F17000 = 6 THEN 'Seguro/Fiança Bancária'
        ELSE 'Teste'
    END AS tipo_bem_envolvido,
    CASE
        WHEN a.F11573 = 1 THEN 'Penhora'
        WHEN a.F11573 = 2 THEN 'Caução'
        WHEN a.F11573 = 3 THEN 'Busca e Apreensão'
        ELSE NULL
    END AS tipo,
    b.F15703 AS tipo_garantia,
    e.F00403 AS veiculo,
    a.F11574 AS valor,
    a.F15678 AS valor_garantia
FROM [ramaprod].[dbo].T00074 AS a
LEFT JOIN [ramaprod].[dbo].T01292 AS b ON a.F15677 = b.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS c ON a.F15674 = c.ID
LEFT JOIN [ramaprod].[dbo].T00035 AS d ON c.F01187 = d.ID
LEFT JOIN [ramaprod].[dbo].T00071 AS e ON a.F17004 = e.ID
WHERE c.F25017 <> 2 AND c.F14474 IS NOT NULL),
processos AS (
SELECT
	d.ID AS id,
	a.F04461 AS pasta,
	MAX(d.F14474) AS dossie,
	MAX(e.F01062) AS criado_em,
	MAX(
	CASE
		WHEN f.F25017 = 1 THEN 'Ativo'
		WHEN f.F25017 = 2 THEN 'Encerrado'
		WHEN f.F25017 = 3 THEN 'Acordo'
		WHEN f.F25017 = 4 THEN 'Em encerramento'
		ELSE 'Em precatório (Ativo)'
	END)  AS situacao,
	MAX(s.F00227) AS desdobramento_nome,
	MAX(m.F01130) AS carteira,
	MAX(f.F16334) AS data_garantia,
	MAX(
		CASE
			WHEN d.F47441 = 1 THEN 'E1'
			WHEN d.F47441 = 2 THEN 'PF'
			WHEN d.F47441 = 3 THEN 'E2 Risco menor que 500K'
			WHEN d.F47441 = 4 THEN 'E2 Risco maior que 500K'
			WHEN d.F47441 = 5 THEN 'E3'
			WHEN d.F47441 = 6 THEN 'GIU'
			WHEN d.F47441 = 7 THEN 'FAMPE'
			WHEN d.F47441 = 8 THEN 'PRIVATE'
		END ) AS segmento,
	MAX(h.F00162) AS fase,
	MAX(g.F43686) AS subfase,
	MAX(f.F34969) AS tipo_acao,
	MAX(f.F00179) AS valor_causa,
	MAX(i.F00091) AS advogado_interno,
	MAX(k.F02568) AS comarca,
	MAX(n.F00091) AS adverso,
	MAX(
		CASE
			WHEN n.F00148 = 1 THEN 'PF'
			WHEN n.F00148 = 2 THEN 'PJ'
			WHEN n.F00148 = 3 THEN 'Espólio'
		END) AS tipo_pessoa,
	MAX(n.F27086) AS cpf_cnpj,
	MAX(
		CASE
			WHEN j.F01132 IN ('Homologação 1.3 - Ajuizamento', 'BA 1.1 - Distribuição da ação', 
				'Execução 1.1 - Data distribuição da ação', 'Monitória 1.4 - Ajuizamento', 'Cobrança 1.4 - Ajuizamento') THEN j.F01132
			ELSE NULL
		END) AS evento_ajuizamento,
	MAX(
		CASE
			WHEN j.F01132 IN ('Homologação 1.3 - Ajuizamento', 'BA 1.1 - Distribuição da ação', 
				'Execução 1.1 - Data distribuição da ação', 'Monitória 1.4 - Ajuizamento', 'Cobrança 1.4 - Ajuizamento') THEN a.F00385
			ELSE NULL
		END) AS data_ajuizamento,
	MAX(
		CASE
			WHEN j.F01132 IN ('Homologação 1.3 - Ajuizamento', 'BA 1.1 - Distribuição da ação', 
				'Execução 1.1 - Data distribuição da ação', 'Monitória 1.4 - Ajuizamento', 'Cobrança 1.4 - Ajuizamento') THEN b.F00689
			ELSE NULL
		END) AS advogado_ajuizamento
FROM [ramaprod].[dbo].T00069 AS a
LEFT JOIN [ramaprod].[dbo].T00003 AS b ON a.F08501 = b.ID
LEFT JOIN [ramaprod].[dbo].T00064 AS c ON a.F01133 = c.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS d ON a.F02003 = d.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS e ON a.F02003 = e.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS f ON a.F02003 = f.ID
LEFT JOIN [ramaprod].[dbo].T02682 AS g ON f.F43687 = g.ID
LEFT JOIN [ramaprod].[dbo].T00037 AS h ON f.F00177 = h.ID
LEFT JOIN [ramaprod].[dbo].T00030 AS i ON f.F11578 = i.ID
LEFT JOIN [ramaprod].[dbo].T00064 AS j ON a.F01133 = j.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS k ON a.F02003 = k.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS l ON a.F02003 = l.ID
LEFT JOIN [ramaprod].[dbo].T00035 AS m ON f.F01187 = m.ID
LEFT JOIN [ramaprod].[dbo].T00030 AS n ON f.F05220 = n.ID
LEFT JOIN [ramaprod].[dbo].T00045 AS o ON f.F00217 = o.ID
LEFT JOIN [ramaprod].[dbo].T01777 AS p ON f.F34969 = p.ID
LEFT JOIN [ramaprod].[dbo].T00035 AS q ON p.F24930 = q.ID
LEFT JOIN [ramaprod].[dbo].T00083 AS r ON f.F14465 = r.ID
LEFT JOIN [ramaprod].[dbo].T00046 AS s ON r.F00488 = s.ID
GROUP BY a.F04461, d.ID
)
SELECT
    a.dossie AS dossie_processo,
    b.dossie AS dossie_garantia,
    a.criado_em AS data_criacao,
    a.carteira AS carteira,
    a.tipo_pessoa AS tipo_pessoa
FROM processos AS a
LEFT JOIN garantias AS b 
    ON a.dossie = b.dossie 
WHERE 
    b.dossie IN (SELECT dossie FROM garantias) AND
    a.evento_ajuizamento IS NOT NULL;