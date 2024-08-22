-- Tabela fato de penhoras jurídico varejo 

SELECT
	a.F04461 AS pasta,
	d.F14474 AS dossie,
	a.F01544 AS criado_em,
	CASE
		WHEN f.F25017 = 1 THEN 'Ativo'
		WHEN f.F25017 = 2 THEN 'Encerrado'
		WHEN f.F25017 = 3 THEN 'Acordo'
		WHEN f.F25017 = 4 THEN 'Em encerramento'
		ELSE 'Em precatório (Ativo)'
	END  AS situacao,
	m.F01130 AS carteira,
	h.F00162 AS fase,
	g.F43686 AS subfase,
	j.F01132 AS evento,
	n.F00091 AS adverso,
	CASE
		WHEN n.F00148 = 1 THEN 'PF'
		WHEN n.F00148 = 2 THEN 'PJ'
		WHEN n.F00148 = 3 THEN 'Espólio'
	END AS tipo_pessoa,
	n.F27086 AS cpf_cnpj,
	CASE
		WHEN j.F01132 IN ('Execução 7.3.2 - Penhora de imóveis insuficiente', 'Execução 7.9.2 - Penhora de percentual de faturamento insuficiente', 'Execução 7.1.2 - Penhora de valores insuficiente', 'Execução 6.2.1 - Deferido bloqueio Renajud', 'Execução 7.14.2 - Penhora de direitos creditórios insuficiente', 'Execução 7.8.2 - Penhora de ações e quotas insuficiente', 'Execução 7.11.2 - Penhora de direitos aquisitivos insuficiente') THEN a.F00385
		ELSE NULL
	END AS data_evento,
	i.F00091 AS advogado_interno,
	b.F00689 AS advogado,
	k.F02568 AS comarca,
    SUBSTRING(l.F02571, CHARINDEX('/', l.F02571 + '/') + 1, LEN(l.F02571)) AS cartorio,
    SUBSTRING(l.F02571, CHARINDEX('/', l.F02571 + '/') + 1, LEN(l.F02571)) + '-' + k.F02568 AS comarca_cartorio,
	CASE
		WHEN l.F02571 LIKE '%Grande do sul%' THEN 'Rio Grande do Sul'
		WHEN l.F02571 LIKE '%Paraná%' THEN 'Paraná'
		ELSE 'Santa Catarina'
	END AS estado
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
WHERE j.F01132 IN
	('Execução 7.3.2 - Penhora de imóveis insuficiente', 'Execução 7.9.2 - Penhora de percentual de faturamento insuficiente', 'Execução 7.1.2 - Penhora de valores insuficiente', 'Execução 6.2.1 - Deferido bloqueio Renajud', 'Execução 7.14.2 - Penhora de direitos creditórios insuficiente', 'Execução 7.8.2 - Penhora de ações e quotas insuficiente', 'Execução 7.11.2 - Penhora de direitos aquisitivos insuficiente')

