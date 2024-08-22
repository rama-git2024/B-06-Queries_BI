-- Tabela dimensão cadastro de carteiras e seus setores 
WITH carteira AS (
	SELECT
		ID AS id,
		F01130 AS carteira,
		F01130 AS carteira_ref,
		CASE
			WHEN F01130 IN ('E1', 'Massificado PJ', 'PF', 'Massificado PJ - E2', 'E2', 'Autos Santander', 'Alto Ticket') THEN 'Varejo'
			WHEN F01130 IN ('Falência', 'Recuperação Judicial', 'Empresas 3 - Núcleo Massificado', 'Credito Rural', 'Empresas 3 - Judicial Especializado', 'Recuperação Judicial - Empresas 3', 
			'Recuperação Judicial - Empresas 1 e 2', 'Falência - Empresas 1 e 2', 'Falência - Empresas 3', 'Leasing', 'Recuperação Judicial - Créditos Especiais', 'Recuperação Judicial - Produtor Rural', 'Falência - Créditos Especiais', 'Créditos Especiais - Special Credits' ) THEN 'Especializado'
			WHEN F01130 IN ('Crédito Imobiliário', 'IMOB - Financiamento', 'PF', 'IMOB - Hipoteca', 'IMOB - Home Equity PF', 'IMOB - Home Equity PJ') THEN 'Jurídico imobiliário'
			ELSE 'Outro'
		END AS setor
	FROM [ramaprod].[dbo].T00035
),
segmento AS (
	SELECT




)
