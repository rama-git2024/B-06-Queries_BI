--Tabela dimensão cadastro de comarcas 

SELECT
	ROW_NUMBER() OVER (ORDER BY a.F00230 ASC) AS id_comarca,
	a.F00230 AS comarca,
	a.F00230 AS comarca_ref,
	MAX(b.F00075) AS estado,
	MAX(b.F00074) AS UF
FROM [ramaprod].[dbo].T00049 AS a
LEFT JOIN [ramaprod].[dbo].T00023 AS b ON a.F00232 = b.ID
GROUP BY a.F00230
ORDER BY a.F00230 ASC;


SELECT
	a.F00230 AS comarca,
	a.F00230 AS comarca_ref,
	a.F00230 AS juizo,
	MAX(b.F00075) AS estado,
	MAX(b.F00074) AS UF,
	(a.F00230 + '-' + b.F00074) AS comarca_UF
FROM [ramaprod].[dbo].T00049 AS a
LEFT JOIN [ramaprod].[dbo].T00023 AS b ON a.F00232 = b.ID
GROUP BY (a.F00230 + '-' + b.F00074), a.F00230
ORDER BY a.F00230 ASC;