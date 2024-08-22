-- Tabela dimensão cadastro de pessoa (advogados, adverso e criadores de processos)
SELECT
	a.ID AS id_pessoas,
	b.ID AS id_login,
	a.F00091 AS advogado,
	a.F00091 AS advogado_ref,
	LEFT(a.F00091, CHARINDEX(' ', a.F00091 + ' ') - 1) AS primeiro_nome_adv,
	SUBSTRING(a.F00091, LEN(a.F00091) - CHARINDEX(' ', REVERSE(a.F00091)) + 2, LEN(a.F00091)) AS ultimo_nome,
	LEFT(a.F00091, CHARINDEX(' ', a.F00091 + ' ') - 1)+' '+SUBSTRING(a.F00091, LEN(a.F00091) - CHARINDEX(' ', REVERSE(a.F00091)) + 2, LEN(a.F00091)) AS nome_sobrenome,
	a.F00114 AS data_admissao,
	a.F00115 AS data_demissao,
	CASE
		WHEN a.F00091	IN ('Luize Cezar dos Santos','Jocelaine Rodrigues Machado', 'Luanni dos Santos Jardim') THEN 'Indicações'
		WHEN a.F00091	IN ('Prescila Koiwaske', 'Danielle Silva de Souza', 'Rafaela Botona Nunes') THEN 'Ajuizamento'
		WHEN a.F00091	IN ('Manoela Trindade de Pauli', 'Ketlin Caroline Marques Soares') THEN 'Acordos'
		WHEN a.F00091	IN ('Karla Fernanda Oliveira Paulo', 'Marcos Antonio Rodrigues Junior', 'Jonathan Viegas Avila Cruz') THEN 'Citações'
		WHEN a.F00091	IN ('Simone da Silva Fagundes', 'Roberto da Silva Lima', 'Bruno Melo Vinhatti', 'Raquel Costa Morussi','Andrea Lessa Gullo', 'Andressa Pereira de Mattos', 'Tarcisio Froes', 'Alexandra Uczak da Gama') THEN 'Penhoras'
		WHEN a.F00091	IN ('Rosana Teixeira da Silveira', 'Vinicius Cainã Pinheiro', 'Ananda Piegas Piffero') THEN 'Controladoria'
		WHEN a.F00091	= 'Aline Viganigo de Moraes Alves' THEN 'Recursos'
		WHEN a.F00091   IN ('Simone da Rosa Godolphim', 'Cariziane de Souza Mauat','Alessandra Borba Longo' ) THEN 'Supervisão'
		WHEN a.F00091	IN ('Sirlei Maria Rama Vieira Silveira', 'Daniela Peres Marques Silveira') THEN 'Sócia'
		ELSE NULL
	END AS nucleo
FROM [ramaprod].[dbo].T00030 AS a
LEFT JOIN [ramaprod].[dbo].T00003 AS b ON a.F00091 = b.F00689
WHERE
	(CASE
		WHEN a.F00091	IN ('Luize Cezar dos Santos','Jocelaine Rodrigues Machado', 'Luanni dos Santos Jardim') THEN 'Indicações'
		WHEN a.F00091	IN ('Prescila Koiwaske', 'Danielle Silva de Souza', 'Rafaela Botona Nunes') THEN 'Ajuizamento'
		WHEN a.F00091	IN ('Manoela Trindade de Pauli', 'Ketlin Caroline Marques Soares') THEN 'Acordos'
		WHEN a.F00091	IN ('Karla Fernanda Oliveira Paulo', 'Marcos Antonio Rodrigues Junior', 'Jonathan Viegas Avila Cruz') THEN 'Citações'
		WHEN a.F00091	IN ('Simone da Silva Fagundes', 'Roberto da Silva Lima', 'Bruno Melo Vinhatti', 'Raquel Costa Morussi','Andrea Lessa Gullo', 'Andressa Pereira de Mattos', 'Tarcisio Froes', 'Alexandra Uczak da Gama') THEN 'Penhoras'
		WHEN a.F00091	IN ('Rosana Teixeira da Silveira', 'Vinicius Cainã Pinheiro', 'Ananda Piegas Piffero') THEN 'Controladoria'
		WHEN a.F00091	= 'Aline Viganigo de Moraes Alves' THEN 'Recursos'
		WHEN a.F00091   IN ('Simone da Rosa Godolphim', 'Cariziane de Souza Mauat','Alessandra Borba Longo' ) THEN 'Supervisão'
		WHEN a.F00091	IN ('Sirlei Maria Rama Vieira Silveira', 'Daniela Peres Marques Silveira') THEN 'Sócia'
		ELSE NULL
	END) IS NOT NULL;




