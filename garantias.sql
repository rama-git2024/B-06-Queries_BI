-- Tabala com garantias processos de varejo e especializado 
SELECT
    c.F14474 AS dossie,
    d.F01130 AS carteira,
    CASE 
    	WHEN c.F25017 = 1 THEN 'Ativo'
    	WHEN c.F25017 = 2 THEN 'Encerrado'
    	WHEN c.F25017 = 3 THEN 'Acordo'
    	WHEN c.F25017 = 6 THEN 'Em encerramento'
    	WHEN c.F25017 = 4 THEN 'Em precatório (Ativo)'
    END AS situacao,
    s.F00227 AS desdobramento_nome,
    c.F11581 AS data_distribuicao,
    c.F15680 AS data_citacao,
    g.F00493 AS numero_processo,
    COALESCE(z.F43630, 'Sem subfase') AS subfase_veiculo,
    COALESCE(w.F43644, 'Sem subfase') AS subfase_outros,
    COALESCE(y.F43637, 'Sem subfase') AS subfase_valores,
    CASE
        WHEN a.F17000 = 1 THEN 'BacenJUD'
        WHEN a.F17000 = 2 THEN 'Equipamento'
        WHEN a.F17000 = 3 THEN 'Imóvel'
        WHEN a.F17000 = 4 THEN 'Veículo'
        WHEN a.F17000 = 5 THEN 'Outros'
        WHEN a.F17000 = 6 THEN 'Seguro/Fiança Bancária'
        ELSE 'Capitalização'
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
    a.F15678 AS valor_garantia,
    f.F00162 AS fase
FROM [ramaprod].[dbo].T00074 AS a
LEFT JOIN [ramaprod].[dbo].T01292 AS b ON a.F15677 = b.ID
LEFT JOIN [ramaprod].[dbo].T00041 AS c ON a.F15674 = c.ID
LEFT JOIN [ramaprod].[dbo].T00035 AS d ON c.F01187 = d.ID
LEFT JOIN [ramaprod].[dbo].T00071 AS e ON a.F17004 = e.ID
LEFT JOIN [ramaprod].[dbo].T00037 AS f ON c.F00177 = f.ID
LEFT JOIN [ramaprod].[dbo].T02676 AS z ON c.F43645 = z.ID
LEFT JOIN [ramaprod].[dbo].T02678 AS w ON c.F43647 = w.ID
LEFT JOIN [ramaprod].[dbo].T02677 AS y ON c.F43646 = y.ID
LEFT JOIN [ramaprod].[dbo].T00083 AS g ON c.F14465 = g.ID
LEFT JOIN [ramaprod].[dbo].T00083 AS r ON c.F14465 = r.ID  
LEFT JOIN [ramaprod].[dbo].T00046 AS s ON r.F00488 = s.ID

WHERE c.F25017 <> 2 AND c.F14474 IS NOT NULL



