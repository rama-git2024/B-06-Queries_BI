WITH subquery AS (
SELECT DISTINCT
    x.F47448 AS segmento_novo_pessoa,
    (CASE
        WHEN x.F47448 IN ('E2 POLO', 'BAIXO TICKET') THEN 'Varejo'
        WHEN x.F47448 IN ('E3', 'AGRO') THEN 'Especializado'
        ELSE 'Outro'
    END) AS setor
FROM [ramaprod].[dbo].T00041 AS a
LEFT JOIN [ramaprod].[dbo].T00030 AS v ON a.F05220 = v.ID
LEFT JOIN [ramaprod].[dbo].T02913 AS x ON v.F47449 = x.ID
LEFT JOIN [ramaprod].[dbo].T00035 AS f ON a.F01187 = f.ID
WHERE x.F47448 IS NOT NULL
)
SELECT 
	ROW_NUMBER() OVER (ORDER BY segmento_novo_pessoa) AS indice_segmento,
    segmento_novo_pessoa,
	setor
FROM subquery;



------------------------------------------------

-- Query obsoleta classificação de setor pela carteira

WITH subquery AS (
SELECT DISTINCT
    f.F01130 AS carteira,
    f.F01130 AS carteira_ref,
    (CASE
        WHEN f.F01130 IN ('E1', 'Massificado PJ', 'PF', 'Massificado PJ - E2', 'E2', 'Autos Santander', 'Alto Ticket', 'Massificado PJ','Diligência Varejo Massificado') THEN 'Varejo'
        WHEN f.F01130 = 'Créditos Especiais - Special Credits' AND x.F47448 IN ('E2 POLO', 'BAIXO TICKET') THEN 'Varejo'
        WHEN f.F01130 IN ('Falência', 'Recuperação Judicial', 'Empresas 3 - Núcleo Massificado', 'Credito Rural', 'Empresas 3 - Judicial Especializado', 'Recuperação Judicial - Empresas 3', 
        'Recuperação Judicial - Empresas 1 e 2', 'Falência - Empresas 1 e 2', 'Falência - Empresas 3', 'Leasing', 'Recuperação Judicial - Créditos Especiais', 'Recuperação Judicial - Produtor Rural', 
        'Falência - Créditos Especiais', 'Créditos Especiais - Special Credits', 'E3' ) THEN 'Especializado'
        ELSE 'Outro'
    END) AS setor,
    x.F47448 AS segmento_novo_pessoa
FROM [ramaprod].[dbo].T00041 AS a
LEFT JOIN [ramaprod].[dbo].T00030 AS v ON a.F05220 = v.ID
LEFT JOIN [ramaprod].[dbo].T02913 AS x ON v.F47449 = x.ID
LEFT JOIN [ramaprod].[dbo].T00035 AS f ON a.F01187 = f.ID
WHERE f.F01130 IS NOT NULL
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY carteira) AS indice_carteira,
    carteira,
    carteira_ref,
    setor
FROM subquery;
