SELECT
	d.ID AS id,
	a.F04461 AS pasta,
	d.F14474 AS dossie,
	e.F01062 AS criado_em,
	CASE
		WHEN f.F25017 = 1 THEN 'Ativo'
		WHEN f.F25017 = 2 THEN 'Encerrado'
		WHEN f.F25017 = 3 THEN 'Acordo'
		WHEN f.F25017 = 4 THEN 'Em encerramento'
		ELSE 'Em precatório (Ativo)'
	END  AS situacao,
	s.F00227 AS desdobramento_nome,
	aa.F00156 AS tipo_acao,
	m.F01130 AS carteira,
	CASE 
		WHEN m.F01130 IN ('E1', 'Massificado PJ', 'PF', 'Massificado PJ - E2', 'E2', 'Autos Santander', 'Alto Ticket', 'Massificado PJ','Diligência Varejo Massificado') THEN 'Varejo'
		WHEN m.F01130 = 'Créditos Especiais - Special Credits' AND x.F47448 IN ('E2 POLO', 'BAIXO TICKET') THEN 'Varejo'
		WHEN m.F01130 IN ('Empresas 3 - Judicial Especializado', 'Empresas 3 - Núcleo Massificado', 'Créditos Especiais - Special Credit') AND x.F47448 = 'E3' THEN 'E3'
		WHEN m.F01130 IN ('Falência', 'Falência - Créditos Especiai', 'Falência - Empresas 1 e 2', 'Falência - Empresas 3', 'Recuperação Judicial', 'Recuperação Judicial - Créditos Especiais',
            'Recuperação Judicial - Empresas 1 e 2', 'Recuperação Judicial - Empresas 3', 'Recuperação Judicial - Empresas 1 e 2 Baixo Ticket', 'Recuperação Judicial - Produtor Rural') THEN 'Falência e RJ'
		WHEN m.F01130 = 'Credito Rural' THEN 'Agro'
		ELSE 'Outro'
    END AS setor,
	CASE
		WHEN d.F47441 = 1 THEN 'E1'
		WHEN d.F47441 = 2 THEN 'PF'
		WHEN d.F47441 = 3 THEN 'E2 Risco menor que 500K'
		WHEN d.F47441 = 4 THEN 'E2 Risco maior que 500K'
		WHEN d.F47441 = 5 THEN 'E3'
		WHEN d.F47441 = 6 THEN 'GIU'
		WHEN d.F47441 = 7 THEN 'FAMPE'
		WHEN d.F47441 = 8 THEN 'PRIVATE'
	END AS segmento,
	t.F47448 AS segmento_novo,
	x.F47448 AS segmento_novo_pessoa,
	CASE
		WHEN v.F47449 = 1 THEN 'GOVERNAMENTAL'
		WHEN v.F47449 = 2 THEN 'CRÉDITO IMOBILIÁRIO'
		WHEN v.F47449 = 3 THEN 'BAIXO TICKET'
		WHEN v.F47449 = 4 THEN 'E2 POLO'
		WHEN v.F47449 = 5 THEN 'E3'
		WHEN v.F47449 = 6 THEN 'GIU'
		WHEN v.F47449 = 7 THEN 'FAMPE'
		WHEN v.F47449 = 8 THEN 'PRIVATE'
		WHEN v.F47449 = 9 THEN 'IMOB - Home Equity PJ'
		WHEN v.F47449 = 10 THEN 'AGRO'
		ELSE NULL 
	END AS segmento_tratado,
	h.F00162 AS fase,
	g.F43686 AS subfase,
	COALESCE(z.F43630, 'Sem subfase') AS subfase_veiculo,
	COALESCE(w.F43644, 'Sem subfase') AS subfase_outros,
	COALESCE(y.F43637, 'Sem subfase') AS subfase_valores,
	f.F34969 AS tipo_acao,
	f.F00179 AS valor_causa,
	i.F00091 AS advogado_interno,
	k.F02568 AS comarca,
    SUBSTRING(l.F02571, CHARINDEX('/', l.F02571 + '/') + 1, LEN(l.F02571)) AS cartorio,
    SUBSTRING(l.F02571, CHARINDEX('/', l.F02571 + '/') + 1, LEN(l.F02571)) + '-' + k.F02568 AS comarca_cartorio,
	CASE
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
	END AS estado,
	n.F00091 AS adverso,
	CASE
		WHEN n.F00148 = 1 THEN 'PF'
		WHEN n.F00148 = 2 THEN 'PJ'
		WHEN n.F00148 = 3 THEN 'Espólio'
	END AS tipo_pessoa,
	n.F27086 AS cpf_cnpj,
	CASE
		WHEN d.F14474 IN (
			SELECT DISTINCT 
				b.F14474
			FROM [ramaprod].[dbo].T00069 AS a
			LEFT JOIN [ramaprod].[dbo].T00041 AS b ON a.F02003 = b.ID
			LEFT JOIN [ramaprod].[dbo].T00064 AS c ON a.F01133 = c.ID
			WHERE (CASE WHEN c.F01132 = 'Operação com Garantia' THEN 'Sim' ELSE 'Não' END) = 'Sim'
			) THEN 'Sim'
		ELSE 'Não'
	END AS processo_ajuizado_tem_garantia,
	d.F15680 AS data_citacao,
	j.F01132 AS evento,
	a.F00385 AS data_evento,
 	b.F00689 AS advogado_evento,
	CASE
		WHEN j.F01132 IN ('Cobrança 2.11 -  Citação por carta precatória positiva','Monitória 2.11- Citação por carta precatória positiva','Execução 3.11 - Citação por Carta Precatória positiva',
				'BA 3.8 - Citação por carta precatória positiva') THEN 'AR/Mandado'
		WHEN j.F01132 IN ('Cobrança 2.12 - Citação por acordo', 'Monitória 2.12 - Citação por acordo', 'Execução 3.14 – Citação por acordo') THEN 'Acordo'
		WHEN j.F01132 IN ('Cobrança 2.1 -  Citação devedor principal', 'Monitória 2.1 - Citação devedor principal','Execução 3.1 - Citação devedor principal',
			 'BA 3.6 - Citação efetivada (com retomada)') THEN 'AR/Mandado'
		ELSE NULL
	END AS tipo_citacao,
	CASE
		WHEN j.F01132 = 'Execução 12.2 - Amortização de valores' THEN 'Alvará'
		WHEN j.F01132 = 'BA 4.19 - Venda do bem' THEN 'Venda de bem'
		ELSE NULL
	END AS tipo_financeiro,
	CASE
		WHEN j.F01132 IN ('Execução 12.2 - Amortização de valores', 'BA 4.19 - Venda do bem', 'DP 1.6.1 - Operação liquidada') AND YEAR(a.F00385) = 2024 AND m.F01130 NOT LIKE 'IMOB%' THEN CONVERT(VARCHAR, a.F00395)
		ELSE NULL 
	END AS valor_financeiro,
	CASE
		WHEN j.F01132 = 'Acordo - Negociação (Principal)' THEN 'Não formalizado'
		WHEN j.F01132 = 'Acordo cancelado' THEN 'Cancelado'
		WHEN j.F01132 = 'Acordo - Termo Enviado para Protocolo' THEN 'Formalizado'
		ELSE NULL
	END AS status_acordo,
	CASE
		WHEN j.F01132 IN ('Acordo - Negociação (Principal)', 'Acordo cancelado', 'Acordo - Termo Enviado para Protocolo') THEN 'Processual'
		ELSE NULL
	END AS tipo_acordo,
	CASE 
		WHEN j.F01132 = 'Execução 13.3 - Parecer de irrecuperabilidade elaborado' THEN 'Irrecuperabilidades solicitadas'
		WHEN j.F01132 = 'Parecer de irrecuperabilidade aprovado' THEN 'Irrecuperabilidades aprovadas'
		ELSE NULL
	END AS irrecuperabilidade
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
LEFT JOIN [ramaprod].[dbo].T02676 AS z ON d.F43645 = z.ID
LEFT JOIN [ramaprod].[dbo].T02678 AS w ON d.F43647 = w.ID
LEFT JOIN [ramaprod].[dbo].T02677 AS y ON d.F43646 = y.ID
LEFT JOIN [ramaprod].[dbo].T00034 AS aa ON d.F01122 = aa.ID
WHERE 
	YEAR(a.F00385) >= YEAR(GETDATE()) - 5 AND 
	(j.F01132 IN (
		'Indicação do Acompanhamento' ,'Dentro da Régua de Ajuizamento' ,'Operação com Garantia', 'Solicitada Planilha de Cálculos', 'Fora da Régua de Ajuizamento',
		'Homologação 1.3 - Ajuizamento', 'BA 1.1 - Distribuição da ação', 'Execução 1.1 - Data distribuição da ação','Monitória 1.4 - Ajuizamento', 'Cobrança 1.4 - Ajuizamento', 
		'Cobrança 2.1 -  Citação devedor principal', 'Cobrança 2.11 -  Citação por carta precatória positiva', 
		'Cobrança 2.12 - Citação por acordo', 'Monitória 2.1 - Citação devedor principal', 'Monitória 2.11- Citação por carta precatória positiva', 'Monitória 2.12 - Citação por acordo', 
		'Execução 3.1 - Citação devedor principal',	'Execução 3.11 - Citação por Carta Precatória positiva', 'Execução 3.14 – Citação por acordo', 'BA 3.6 - Citação efetivada (com retomada)', 
		'BA 3.8 - Citação por carta precatória positiva', 'BA 4.21 - Citação efetivada (com retomada)', 'BA 4.18 - Citação efetivada (sem retomada)', 'BA 3.5 - Citação efetivada (sem retomada)',
		'Cobrança 2.2 -  Citação coobrigado', 'BA 6.1 - Conversão para execução deferida', 'Execução 3.2 - Citação coobrigado', 'Monitória 2.2 - Citação coobrigado',
		'BA 3.1 - Retomada efetivada', 'Execução 8.3.4 - Remoção de bem penhorado', 'BA 4.14 - Retomada efetivada',	'BA 8.6 - Entrega amigável realizada', 
		'Venda de Bem em Leilão','Execução 12.2 - Amortização de valores', 'BA 4.19 - Venda do bem', 'DP 1.6.1 - Operação liquidada',
		'Acordo - Negociação (Principal)', 'Acordo cancelado', 'Acordo - Termo Enviado para Protocolo', 
		'Execução 2.2 - Deferido arresto liminar', 'Execução 6.2.1 - Deferido bloqueio Renajud','Execução 7.1.1 - Penhora de valores suficiente', 'Execução 7.1.2 - Penhora de valores insuficiente', 
		'Execução 7.2.1 - Penhora de veículos suficiente',
		'Execução 7.2.2 - Penhora de veículos insuficiente', 'Execução 7.3.1 - Penhora de imóveis suficiente', 'Execução 7.3.2 - Penhora de imóveis insuficiente',
		'Execução 7.4.1 - penhora de bens móveis suficientes', 'Execução 7.4.2 - penhora de bens móveis insuficiente', 'Execução 7.5.1 - Penhora de títulos e valores mobiliários suficiente',
		'Execução 7.5.2 - Penhora de títulos e valores mobiliários insuficiente', 'Execução 7.6.1 - Penhora de semoventes suficiente', 'Execução 7.6.2 - Penhora de semoventes insuficiente',
		'Execução 7.7.1 - Penhora de navios / aeronaves suficiente', 'Execução 7.7.2 - Penhora de navios/aeronaves insuficiente', 'Execução 7.8.1 - Penhora de ações e quotas suficiente',
		'Execução 7.8.2 - Penhora de ações e quotas insuficiente', 'Execução 7.9.1 - Penhora de percentual de faturamento suficiente', 'Execução 7.9.2 - Penhora de percentual de faturamento insuficiente',
		'Execução 7.10.1 - Penhora de pedras e metais preciosos suficiente', 'Execução 7.10.2 - Penhora de pedras e metais preciosos insuficiente',
		'Execução 7.11.1 - Penhora de direitos aquisitivos suficiente', 'Execução 7.11.2 - Penhora de direitos aquisitivos insuficiente', 'Execução 7.12.1 - penhora de outros direitos suficiente',
		'Execução 7.12.2 - Penhora de outros direitos insuficiente', 'Execução 7.13.1 - Penhora no rosto dos autos suficiente', 'Execução 7.13.2 - Penhora no rosto dos autos insuficiente',
		'Execução 7.14.1 - Penhora de direitos creditórios suficiente', 'Execução 7.14.2 - Penhora de direitos creditórios insuficiente', 'Execução 7.15.1 - Penhora de vencimentos suficiente',
		'Execução 7.15.2 - Penhora de vencimentos insuficiente', 'Execução 7.16.1 - Penhora de moeda digital suficiente', 'Execução 7.16.2 - Penhora de moeda digital insuficiente',
		'Execução 13.3 - Parecer de irrecuperabilidade elaborado','Parecer de irrecuperabilidade aprovado',
		'Andamento'))
ORDER BY criado_em DESC;