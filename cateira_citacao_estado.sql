WITH processos AS (
	SELECT
		a.F04461 AS pasta,
		d.F14474 AS dossie,
		max(e.F01062) AS criado_em,
		MAX(k.F02568) AS comarca,
		MAX(h.F00162) AS fase,
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
		MAX(h.F00162) = 'Citação' AND
		MAX(f.F25017) <> 2
),
eventos_citacao AS (
	SELECT
		a.F04461 AS pasta,
		d.F14474 AS dossie,
		MAX(k.F02568) AS comarca,
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
			'Cobrança 2.1 -  Citação devedor principal', 'Cobrança 2.11 -  Citação por carta precatória positiva', 
			'Cobrança 2.12 - Citação por acordo', 'Monitória 2.1 - Citação devedor principal', 'Monitória 2.11- Citação por carta precatória positiva', 'Monitória 2.12 - Citação por acordo', 
			'Execução 3.1 - Citação devedor principal',	'Execução 3.11 - Citação por Carta Precatória positiva', 'Execução 3.14 – Citação por acordo', 'BA 3.6 - Citação efetivada (com retomada)', 
			'BA 3.8 - Citação por carta precatória positiva', 'BA 4.21 - Citação efetivada (com retomada)')
	GROUP BY d.F14474, a.F04461, j.F01132
	HAVING 
		MAX(f.F25017) <> 2
)
SELECT
	p.criado_em,
	p.dossie AS dossie_processo,
	e.dossie AS dossie_citado,
	p.fase,
	e.evento,
	e.data_evento,
	COALESCE(e.comarca, p.comarca) AS comarca
FROM processos AS p 
LEFT JOIN eventos_citacao AS e ON p.dossie = e.dossie
