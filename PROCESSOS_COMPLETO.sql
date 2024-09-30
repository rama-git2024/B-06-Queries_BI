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
	MAX(
		CASE 
		WHEN m.F01130 IN ('E1', 'Massificado PJ', 'PF', 'Massificado PJ - E2', 'E2', 'Autos Santander', 'Alto Ticket', 'Massificado PJ','Diligência Varejo Massificado') THEN 'Varejo'
		WHEN m.F01130 = 'Créditos Especiais - Special Credits' AND x.F47448 IN ('E2 POLO', 'BAIXO TICKET') THEN 'Varejo'
		WHEN m.F01130 IN ('Empresas 3 - Judicial Especializado', 'Empresas 3 - Núcleo Massificado', 'Créditos Especiais - Special Credit') AND x.F47448 = 'E3' THEN 'E3'
		WHEN m.F01130 IN ('Falência', 'Falência - Créditos Especiai', 'Falência - Empresas 1 e 2', 'Falência - Empresas 3', 'Recuperação Judicial', 'Recuperação Judicial - Créditos Especiais',
            'Recuperação Judicial - Empresas 1 e 2', 'Recuperação Judicial - Empresas 3', 'Recuperação Judicial - Empresas 1 e 2 Baixo Ticket', 'Recuperação Judicial - Produtor Rural') THEN 'Falência e RJ'
		WHEN m.F01130 = 'Credito Rural' THEN 'Agro'
		ELSE 'Outro'
    END )AS setor,
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
    MAX(SUBSTRING(l.F02571, CHARINDEX('/', l.F02571 + '/') + 1, LEN(l.F02571))) AS cartorio,
    MAX(SUBSTRING(l.F02571, CHARINDEX('/', l.F02571 + '/') + 1, LEN(l.F02571)) + '-' + k.F02568) AS comarca_cartorio,
	CASE
		WHEN MAX(l.F02571) LIKE '%Grande do sul%' THEN 'Rio Grande do Sul'
		WHEN MAX(l.F02571) LIKE '%Paraná%' THEN 'Paraná'
		WHEN MAX(l.F02571) LIKE '%Catarina%' THEN 'Santa Catarina'
		WHEN MAX(l.F02571) LIKE '%Distrito%' THEN 'Distrito Federal'
		WHEN MAX(l.F02571) LIKE '%Paulo%' THEN 'São Paulo'
		WHEN MAX(l.F02571) LIKE '%Janeiro%' THEN 'Rio de Janeiro'
		WHEN MAX(l.F02571) LIKE '%Bahia%' THEN 'Bahia'
		WHEN MAX(l.F02571) LIKE '%Cear%' THEN 'Ceará'
		WHEN MAX(l.F02571) LIKE '%Mato Grosso do Sul%' THEN 'Mato Grosso do Sul'
		WHEN MAX(l.F02571) LIKE '%Goiás%' THEN 'Goiás'
		WHEN MAX(l.F02571) LIKE '%Pern%' THEN 'Pernambuco'
		WHEN MAX(l.F02571) LIKE '%Rond%' THEN 'Rondônia'
		ELSE 'Outro'
	END AS estado,
	MAX(n.F00091) AS adverso,
	MAX(
		CASE
			WHEN n.F00148 = 1 THEN 'PF'
			WHEN n.F00148 = 2 THEN 'PJ'
			WHEN n.F00148 = 3 THEN 'Espólio'
		END) AS tipo_pessoa,
	MAX(n.F27086) AS cpf_cnpj,
	MAX(CASE WHEN j.F01132 = 'Operação com Garantia' THEN 'Sim' ELSE 'Não' END) AS tem_garantia,
	MAX(
		CASE
			WHEN j.F01132 = 'Indicação do Acompanhamento' THEN j.F01132
			ELSE NULL
		END) AS evento_indicacao,
	MAX(
		CASE
			WHEN j.F01132 = 'Indicação do Acompanhamento' THEN a.F00385
			ELSE NULL
		END) AS data_indicacao,	
	MAX(
		CASE
			WHEN j.F01132 IN ('Dentro da Régua de Ajuizamento', 'Fora da Régua de Ajuizamento') THEN j.F01132
			ELSE NULL
		END) AS evento_apto_ajuizamento,
	MAX(
		CASE
			WHEN j.F01132 IN ('Dentro da Régua de Ajuizamento', 'Fora da Régua de Ajuizamento') THEN a.F00385
			ELSE NULL
		END) AS data_apto_ajuizamento,
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
		END) AS advogado_ajuizamento,
	MAX(
		CASE
			WHEN j.F01132 IN ('Cobrança 2.1 -  Citação devedor principal', 'Cobrança 2.11 -  Citação por carta precatória positiva', 'Cobrança 2.12 - Citação por acordo', 'Monitória 2.1 - Citação devedor principal',
				'Monitória 2.11- Citação por carta precatória positiva', 'Monitória 2.12 - Citação por acordo', 'Execução 3.1 - Citação devedor principal', 'Execução 3.11 - Citação por Carta Precatória positiva',
				'Execução 3.14 – Citação por acordo', 'BA 3.6 - Citação efetivada (com retomada)', 'BA 3.8 - Citação por carta precatória positiva','Cobrança 2.2 -  Citação coobrigado',
				'Monitória 2.2 - Citação coobrigado', 'Execução 3.2 - Citação coobrigado') THEN j.F01132
			ELSE NULL
		END) AS evento_citacao,
	MAX(
		CASE
			WHEN j.F01132 IN ('Cobrança 2.1 -  Citação devedor principal', 'Cobrança 2.11 -  Citação por carta precatória positiva', 'Cobrança 2.12 - Citação por acordo', 'Monitória 2.1 - Citação devedor principal',
				'Monitória 2.11- Citação por carta precatória positiva', 'Monitória 2.12 - Citação por acordo', 'Execução 3.1 - Citação devedor principal', 'Execução 3.11 - Citação por Carta Precatória positiva',
				'Execução 3.14 – Citação por acordo', 'BA 3.6 - Citação efetivada (com retomada)', 'BA 3.8 - Citação por carta precatória positiva', 'Cobrança 2.2 -  Citação coobrigado',
				'Monitória 2.2 - Citação coobrigado', 'Execução 3.2 - Citação coobrigado') THEN a.F00385
			ELSE NULL
		END) AS data_citacao,
	MAX(
		CASE
			WHEN j.F01132 IN ('Cobrança 2.1 -  Citação devedor principal', 'Cobrança 2.11 -  Citação por carta precatória positiva', 'Cobrança 2.12 - Citação por acordo', 'Monitória 2.1 - Citação devedor principal',
				'Monitória 2.11- Citação por carta precatória positiva', 'Monitória 2.12 - Citação por acordo', 'Execução 3.1 - Citação devedor principal', 'Execução 3.11 - Citação por Carta Precatória positiva',
				'Execução 3.14 – Citação por acordo', 'BA 3.6 - Citação efetivada (com retomada)', 'BA 3.8 - Citação por carta precatória positiva', 'Cobrança 2.2 -  Citação coobrigado',
				'Monitória 2.2 - Citação coobrigado', 'Execução 3.2 - Citação coobrigado') THEN b.F00689
			ELSE NULL
		END) AS advogado_citacao,
	MAX(
		CASE
			WHEN j.F01132 IN ('Cobrança 2.11 -  Citação por carta precatória positiva','Monitória 2.11- Citação por carta precatória positiva','Execução 3.11 - Citação por Carta Precatória positiva',
				'BA 3.8 - Citação por carta precatória positiva') THEN 'AR/Mandado'
			WHEN j.F01132 IN ('Cobrança 2.12 - Citação por acordo', 'Monitória 2.12 - Citação por acordo', 'Execução 3.14 – Citação por acordo') THEN 'Acordo'
			WHEN j.F01132 IN ('Cobrança 2.1 -  Citação devedor principal', 'Monitória 2.1 - Citação devedor principal','Execução 3.1 - Citação devedor principal',
			 'BA 3.6 - Citação efetivada (com retomada)') THEN 'AR/Mandado'
			ELSE NULL
		END) AS tipo_citacao,
	MAX(
		CASE
			WHEN j.F01132 IN ('BA 6.1 - Conversão para execução deferida', 'BA 3.1 - Retomada efetivada', 
				'Execução 8.3.4 - Remoção de bem penhorado', 'BA 4.14 - Retomada efetivada', 'BA 8.6 - Entrega amigável realizada', 
				'Venda de Bem em Leilão') THEN j.F01132
			ELSE NULL
		END) AS evento_retomada,
	MAX(
		CASE
			WHEN j.F01132 IN ('BA 6.1 - Conversão para execução deferida', 'BA 3.1 - Retomada efetivada', 
				'Execução 8.3.4 - Remoção de bem penhorado', 'BA 4.14 - Retomada efetivada', 'BA 8.6 - Entrega amigável realizada', 
				'Venda de Bem em Leilão') THEN a.F00385
			ELSE NULL
		END) AS data_retomada,
	MAX(
		CASE
			WHEN j.F01132 IN ('BA 6.1 - Conversão para execução deferida', 'BA 3.1 - Retomada efetivada', 
				'Execução 8.3.4 - Remoção de bem penhorado', 'BA 4.14 - Retomada efetivada', 'BA 8.6 - Entrega amigável realizada', 
				'Venda de Bem em Leilão') THEN b.F00689
			ELSE NULL
		END) AS advogado_retomada,
	MAX(
		CASE
			WHEN j.F01132 IN ('Execução 7.3.2 - Penhora de imóveis insuficiente', 'Execução 7.9.2 - Penhora de percentual de faturamento insuficiente', 
				'Execução 7.1.2 - Penhora de valores insuficiente', 'Execução 6.2.1 - Deferido bloqueio Renajud', 'Execução 7.14.2 - Penhora de direitos creditórios insuficiente', 
				'Execução 7.8.2 - Penhora de ações e quotas insuficiente', 'Execução 7.11.2 - Penhora de direitos aquisitivos insuficiente') THEN j.F01132
			ELSE NULL
		END) AS evento_penhora,
	MAX(
		CASE
			WHEN j.F01132 IN ('Execução 7.3.2 - Penhora de imóveis insuficiente', 'Execução 7.9.2 - Penhora de percentual de faturamento insuficiente', 
				'Execução 7.1.2 - Penhora de valores insuficiente', 'Execução 6.2.1 - Deferido bloqueio Renajud', 'Execução 7.14.2 - Penhora de direitos creditórios insuficiente', 
				'Execução 7.8.2 - Penhora de ações e quotas insuficiente', 'Execução 7.11.2 - Penhora de direitos aquisitivos insuficiente') THEN a.F00385
			ELSE NULL
		END) AS data_penhora,
	MAX(
		CASE
			WHEN j.F01132 IN ('Execução 7.3.2 - Penhora de imóveis insuficiente', 'Execução 7.9.2 - Penhora de percentual de faturamento insuficiente', 
				'Execução 7.1.2 - Penhora de valores insuficiente', 'Execução 6.2.1 - Deferido bloqueio Renajud', 'Execução 7.14.2 - Penhora de direitos creditórios insuficiente', 
				'Execução 7.8.2 - Penhora de ações e quotas insuficiente', 'Execução 7.11.2 - Penhora de direitos aquisitivos insuficiente') THEN b.F00689
			ELSE NULL
		END) AS advogado_penhora,
	MAX(
	CASE
		WHEN j.F01132 IN ('Execução 12.2 - Amortização de valores', 'BA 4.19 - Venda do bem') THEN j.F01132
		ELSE NULL
	END) AS evento_financeiro,
	MAX(
	CASE
		WHEN j.F01132 = 'Execução 12.2 - Amortização de valores' THEN 'Alvará'
		WHEN j.F01132 = 'BA 4.19 - Venda do bem' THEN 'Venda de bem'
		ELSE NULL
	END) AS tipo_financeiro,
	MAX(
		CASE
			WHEN j.F01132 IN ('Execução 12.2 - Amortização de valores') AND YEAR(GETDATE()) = 2024 THEN CONVERT(VARCHAR, a.F00395)
			ELSE NULL 
		END) AS valor_financeiro,  
	MAX(
	CASE
		WHEN j.F01132 IN ('Execução 12.2 - Amortização de valores', 'BA 4.19 - Venda do bem') THEN a.F00385
		ELSE NULL
	END) AS data_financeiro,
	MAX(
	CASE
		WHEN j.F01132 IN ('Execução 12.2 - Amortização de valores', 'BA 4.19 - Venda do bem') THEN b.F00689
		ELSE NULL
	END) AS advogado_financeiro,
	MAX(
	CASE
		WHEN j.F01132 IN ('Acordo - Negociação (Principal)', 'Acordo cancelado', 'Acordo - Termo Enviado para Protocolo') THEN j.F01132
		ELSE NULL
	END) AS evento_acordo,
	MAX(
	CASE
		WHEN j.F01132 IN ('Acordo - Negociação (Principal)', 'Acordo cancelado', 'Acordo - Termo Enviado para Protocolo') THEN a.F00385
		ELSE NULL
	END) AS data_acordo,
	MAX(
	CASE
		WHEN j.F01132 = 'Acordo - Negociação (Principal)' THEN 'Não formalizado'
		WHEN j.F01132 = 'Acordo cancelado' THEN 'Cancelado'
		WHEN j.F01132 = 'Acordo - Termo Enviado para Protocolo' THEN 'Formalizado'
		ELSE NULL
	END) AS status_acordo,
	MAX(
	CASE
		WHEN j.F01132 IN ('Acordo - Negociação (Principal)', 'Acordo cancelado', 'Acordo - Termo Enviado para Protocolo') THEN b.F00689
		ELSE NULL
	END) AS advogado_acordo,
	MAX(
	CASE
		WHEN j.F01132 IN ('Acordo - Negociação (Principal)', 'Acordo cancelado', 'Acordo - Termo Enviado para Protocolo') THEN 'Processual'
		ELSE NULL
	END) AS tipo_acordo,
	MAX(aa.F00156) AS tipo_acao,
	MIN(
		CASE
			WHEN j.F01132 IN ('Cobrança 2.1 -  Citação devedor principal', 'Cobrança 2.11 -  Citação por carta precatória positiva', 'Cobrança 2.12 - Citação por acordo', 'Monitória 2.1 - Citação devedor principal',
				'Monitória 2.11- Citação por carta precatória positiva', 'Monitória 2.12 - Citação por acordo', 'Execução 3.1 - Citação devedor principal', 'Execução 3.11 - Citação por Carta Precatória positiva',
				'Execução 3.14 – Citação por acordo', 'BA 3.6 - Citação efetivada (com retomada)', 'BA 3.8 - Citação por carta precatória positiva','Cobrança 2.2 -  Citação coobrigado',
				'Monitória 2.2 - Citação coobrigado', 'Execução 3.2 - Citação coobrigado') THEN j.F01132
			ELSE NULL
		END) AS evento_citacao_bi,
	MIN(
		CASE
			WHEN j.F01132 IN ('Cobrança 2.1 -  Citação devedor principal', 'Cobrança 2.11 -  Citação por carta precatória positiva', 'Cobrança 2.12 - Citação por acordo', 'Monitória 2.1 - Citação devedor principal',
				'Monitória 2.11- Citação por carta precatória positiva', 'Monitória 2.12 - Citação por acordo', 'Execução 3.1 - Citação devedor principal', 'Execução 3.11 - Citação por Carta Precatória positiva',
				'Execução 3.14 – Citação por acordo', 'BA 3.6 - Citação efetivada (com retomada)', 'BA 3.8 - Citação por carta precatória positiva', 'Cobrança 2.2 -  Citação coobrigado',
				'Monitória 2.2 - Citação coobrigado', 'Execução 3.2 - Citação coobrigado') THEN a.F00385
			ELSE NULL
		END) AS data_citacao_bi
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
GROUP BY a.F04461, d.ID
ORDER BY criado_em DESC;