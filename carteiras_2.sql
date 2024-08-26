WITH subquery AS (
SELECT DISTINCT
    f.F01130 AS carteira,
    f.F01130 AS carteira_ref,
    (CASE
        WHEN f.F01130 IN ('E1', 'Massificado PJ', 'PF', 'Massificado PJ - E2', 'E2', 'Autos Santander', 'Alto Ticket', 'Massificado PJ','Diligência Varejo Massificado') THEN 'Varejo'
        WHEN f.F01130 = 'Créditos Especiais - Special Credits' AND x.F47448 IN ('E2 POLO', 'BAIXO TICKET') THEN 'Varejo'
        WHEN f.F01130 IN ('Empresas 3 - Judicial Especializado', 'Empresas 3 - Núcleo Massificado', 'Créditos Especiais - Special Credit') AND x.F47448 = 'E3' THEN 'E3'
        WHEN f.F01130 = 'Credito Rural' THEN 'Agro'
        WHEN f.F01130 IN ('Falência', 'Falência - Créditos Especiai', 'Falência - Empresas 1 e 2', 'Falência - Empresas 3', 'Recuperação Judicial', 'Recuperação Judicial - Créditos Especiais',
            'Recuperação Judicial - Empresas 1 e 2', 'Recuperação Judicial - Empresas 3', 'Recuperação Judicial - Empresas 1 e 2 Baixo Ticket', 'Recuperação Judicial - Produtor Rural') THEN 'Falência e RJ'
        ELSE 'Outro'
    END) AS setor
FROM [ramaprod].[dbo].T00041 AS a
LEFT JOIN [ramaprod].[dbo].T00030 AS v ON a.F05220 = v.ID
LEFT JOIN [ramaprod].[dbo].T02913 AS x ON v.F47449 = x.ID
LEFT JOIN [ramaprod].[dbo].T00035 AS f ON a.F01187 = f.ID
WHERE f.F01130 IS NOT NULL
)
SELECT DISTINCT
    setor,
    carteira,
    carteira_ref
FROM subquery;