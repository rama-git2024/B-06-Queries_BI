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
		WHEN a.F00091	IN ('Luize Cezar dos Santos','Jocelaine Rodrigues Machado', 'Pedro Henrique da Silva') THEN 'Indicações'
		WHEN a.F00091	IN ('Prescila Koiwaske', 'Rafaela Botona Nunes', 'Rafaela Roubust dos Santos Garcia') THEN 'Ajuizamento'
		WHEN a.F00091	IN ('Manoela Trindade de Pauli') THEN 'Acordos'
		WHEN a.F00091	IN ('Karla Fernanda Oliveira 
			Paulo', 'Marcos Antonio Rodrigues Junior', 'Vinicius Pereira Souza') THEN 'Citações'
		WHEN a.F00091	IN ('Simone da Silva Fagundes', 'Roberto da Silva Lima', 'Bruno Melo Vinhatti', 'Raquel Costa Morussi','Andrea Lessa Gullo', 'Andressa Pereira de Mattos', 'Tarcisio Froes', 'Caroline Campos Couto', 'Michelle Gonçalves Pinto', 'Débora Cardoso Motta') THEN 'Penhoras'
		WHEN a.F00091	IN ('Rosana Teixeira da Silveira', 'Ananda Piegas Piffero', 'Valeska Graboski Moreira', 'Gabriel Galarça Dutra', 'Pedro Henrique Jardim Centeno') THEN 'Controladoria'
		WHEN a.F00091	IN ('Aline Viganigo de Moraes Alves', 'Andressa Franco Silveira') THEN 'Recursos'
		WHEN a.F00091   IN ('Simone da Rosa Godolphim', 'Alessandra Borba Longo' ) THEN 'Supervisão'
		WHEN a.F00091	IN ('Sirlei Maria Rama Vieira Silveira', 'Daniela Peres Marques Silveira') THEN 'Sócia'
		ELSE NULL
	END AS nucleo
FROM [ramaprod].[dbo].T00030 AS a
LEFT JOIN [ramaprod].[dbo].T00003 AS b ON a.F00091 = b.F00689
WHERE
	(CASE 
		WHEN a.F00091	IN ('Luize Cezar dos Santos','Jocelaine Rodrigues Machado', 'Pedro Henrique da Silva') THEN 'Indicações'
		WHEN a.F00091	IN ('Prescila Koiwaske', 'Rafaela Botona Nunes', 'Rafaela Roubust dos Santos Garcia') THEN 'Ajuizamento'
		WHEN a.F00091	IN ('Manoela Trindade de Pauli') THEN 'Acordos'
		WHEN a.F00091	IN ('Karla Fernanda Oliveira Paulo', 'Marcos Antonio Rodrigues Junior', 'Vinicius Pereira Souza') THEN 'Citações'
		WHEN a.F00091	IN ('Simone da Silva Fagundes', 'Roberto da Silva Lima', 'Bruno Melo Vinhatti', 'Raquel Costa Morussi','Andrea Lessa Gullo', 'Andressa Pereira de Mattos', 'Tarcisio Froes', 'Caroline Campos Couto', 'Michelle Gonçalves Pinto', 'Débora Cardoso Motta') THEN 'Penhoras'
		WHEN a.F00091	IN ('Rosana Teixeira da Silveira', 'Ananda Piegas Piffero', 'Valeska Graboski Moreira', 'Gabriel Galarça Dutra', 'Pedro Henrique Jardim Centeno') THEN 'Controladoria'
		WHEN a.F00091	IN ('Aline Viganigo de Moraes Alves', 'Andressa Franco Silveira') THEN 'Recursos'
		WHEN a.F00091   IN ('Simone da Rosa Godolphim', 'Alessandra Borba Longo' ) THEN 'Supervisão'
		WHEN a.F00091	IN ('Sirlei Maria Rama Vieira Silveira', 'Daniela Peres Marques Silveira') THEN 'Sócia'
		ELSE NULL
	END
	) IS NOT NULL;