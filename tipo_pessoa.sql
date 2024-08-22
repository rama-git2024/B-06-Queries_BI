SELECT DISTINCT
	F00148 AS id_tipo_pessoa,
	CASE
		WHEN F00148 = 1 THEN 'Pessoa Física'
		WHEN F00148 = 2 THEN 'Pessoa Jurídica'
		WHEN F00148 = 3 THEN 'Espólio'
		ELSE NULL
	END AS tipo_pessoa,
	CASE
		WHEN F00148 = 1 THEN 'PF'
		WHEN F00148 = 2 THEN 'PJ'
		WHEN F00148 = 3 THEN 'Espólio'
		ELSE NULL
	END AS tipo_pessoa_sigla,
	CASE
		WHEN F00148 = 1 THEN 'PF'
		WHEN F00148 = 2 THEN 'PJ'
		WHEN F00148 = 3 THEN 'Espólio'
		ELSE NULL
	END AS tipo_pessoa_sigla_ref
FROM [ramaprod].[dbo].T00030