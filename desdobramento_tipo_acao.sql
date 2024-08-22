SELECT DISTINCT
	a.F14465 AS desdobramento_princ,
	a.F14465 AS desdobramento_princ_ref,
	c.F00227 AS desdobramento_nome
FROM [ramaprod].[dbo].T00041 AS a
LEFT JOIN [ramaprod].[dbo].T00083 AS b ON a.F14465 = b.ID
LEFT JOIN [ramaprod].[dbo].T00046 AS c ON b.F00488 = c.ID