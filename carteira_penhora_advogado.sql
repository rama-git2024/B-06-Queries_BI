WITH processos AS (
	SELECT
		a.F04461 AS pasta,
		d.F14474 AS dossie,
		max(e.F01062) AS criado_em,
		MAX(k.F02568) AS comarca,
		MAX(h.F00162) AS fase,
		MAX(i.F00091) AS advogado_interno,
		MAX(CASE
			WHEN l.F02571 LIKE '%Grande do sul%' THEN 'Rio Grande do Sul'
			WHEN l.F02571 LIKE '%Paraná%' THEN 'Paraná'
			WHEN l.F02571 LIKE '%Catarina%' THEN 'Santa Catarina'
			WHEN l.F02571 LIKE '%Distrito%' THEN 'Distrito Federal'
			WHEN l.F02571 LIKE '%Paulo%' THEN 'São Paulo'
			WHEN l.F02571 LIKE '%Janeiro%' THEN 'Rio de Janeiro'
			WHEN l.F02571 LIKE '%Bahia%' THEN 'Bahia'
			WHEN l.F02571 LIKE '%Cear%' THEN 'Ceará'
			WHEN l.F02571 LIKE '%Mato Grosso do Sul%' THEN 'Mato Grosso do Sul'
			WHEN l.F02571 LIKE '%Goiás%' THEN 'Goiás'
			WHEN l.F02571 LIKE '%Pern%' THEN 'Pernambuco'
			WHEN l.F02571 LIKE '%Rond%' THEN 'Rondônia'
			ELSE 'Outro'
		END) AS estado
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
	LEFT JOIN [ramaprod].[dbo].T02913 AS t ON d.F47450 = t.ID
	LEFT JOIN [ramaprod].[dbo].T00030 AS v ON f.F05220 = v.ID
	LEFT JOIN [ramaprod].[dbo].T02913 AS x ON v.F47449 = x.ID
	GROUP BY d.F14474, a.F04461
	HAVING 
		MAX(h.F00162) IN ('Penhora', 'Citação-Penhora', 'Cumprimento de Sentença') AND
		MAX(f.F25017) <> 2
),
eventos_citacao AS (
	SELECT
		a.F04461 AS pasta,
		d.F14474 AS dossie,
		MAX(k.F02568) AS comarca,
		MAX(b.F00689) AS advogado_evento,
		j.F01132 AS evento,
		MAX(a.F00385) AS data_evento
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
	LEFT JOIN [ramaprod].[dbo].T02913 AS t ON d.F47450 = t.ID
	LEFT JOIN [ramaprod].[dbo].T00030 AS v ON f.F05220 = v.ID
	LEFT JOIN [ramaprod].[dbo].T02913 AS x ON v.F47449 = x.ID
	WHERE
		j.F01132 IN (
			'Execução 2.2 - Deferido arresto liminar', 'Execução 6.2.1 - Deferido bloqueio Renajud','Execução 7.1.1 - Penhora de valores suficiente', 'Execução 7.1.2 - Penhora de valores insuficiente', 
		'Execução 7.2.1 - Penhora de veículos suficiente', 'Execução 7.2.2 - Penhora de veículos insuficiente', 'Execução 7.3.1 - Penhora de imóveis suficiente', 'Execução 7.3.2 - Penhora de imóveis insuficiente',
		'Execução 7.4.1 - penhora de bens móveis suficientes', 'Execução 7.4.2 - penhora de bens móveis insuficiente', 'Execução 7.5.1 - Penhora de títulos e valores mobiliários suficiente',
		'Execução 7.5.2 - Penhora de títulos e valores mobiliários insuficiente', 'Execução 7.6.1 - Penhora de semoventes suficiente', 'Execução 7.6.2 - Penhora de semoventes insuficiente',
		'Execução 7.7.1 - Penhora de navios / aeronaves suficiente', 'Execução 7.7.2 - Penhora de navios/aeronaves insuficiente', 'Execução 7.8.1 - Penhora de ações e quotas suficiente',
		'Execução 7.8.2 - Penhora de ações e quotas insuficiente', 'Execução 7.9.1 - Penhora de percentual de faturamento suficiente', 'Execução 7.9.2 - Penhora de percentual de faturamento insuficiente',
		'Execução 7.10.1 - Penhora de pedras e metais preciosos suficiente', 'Execução 7.10.2 - Penhora de pedras e metais preciosos insuficiente',
		'Execução 7.11.1 - Penhora de direitos aquisitivos suficiente', 'Execução 7.11.2 - Penhora de direitos aquisitivos insuficiente', 'Execução 7.12.1 - penhora de outros direitos suficiente',
		'Execução 7.12.2 - Penhora de outros direitos insuficiente', 'Execução 7.13.1 - Penhora no rosto dos autos suficiente', 'Execução 7.13.2 - Penhora no rosto dos autos insuficiente',
		'Execução 7.14.1 - Penhora de direitos creditórios suficiente', 'Execução 7.14.2 - Penhora de direitos creditórios insuficiente', 'Execução 7.15.1 - Penhora de vencimentos suficiente',
		'Execução 7.15.2 - Penhora de vencimentos insuficiente', 'Execução 7.16.1 - Penhora de moeda digital suficiente', 'Execução 7.16.2 - Penhora de moeda digital insuficiente')
	GROUP BY d.F14474, a.F04461, j.F01132
	HAVING 
		MAX(f.F25017) <> 2
)
SELECT
	p.criado_em,
	p.dossie AS dossie_processo,
	e.dossie AS dossie_citado,
	p.advogado_interno,
	e.advogado_evento,
	p.fase,
	e.evento,
	e.data_evento,
	COALESCE(e.comarca, p.comarca) AS comarca
FROM processos AS p 
LEFT JOIN eventos_citacao AS e ON p.dossie = e.dossie
