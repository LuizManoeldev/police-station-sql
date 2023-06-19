--Consultas
-- 2.1 Consulta usando operador basico
--Utilizando between para obter crimes entre os aritgos 100 e 300
SELECT descricao, pena_crime FROM crime
WHERE cod_crime BETWEEN 100 AND 300
ORDER BY cod_crime;

-- 2.2 3 consultas com inner JOIN na cláusula FROM (pode ser self join, caso o  domínio indique esse uso)
-- 1. Nome da Rua de todos os delegados
SELECT nome_delegado, rua FROM delegado d
JOIN endereco e ON d.endereco = e.cep;

-- 2. Delegados e os crimes Investigados por eles.
SELECT nome_delegado,c.cod_crime, c.descricao FROM investigacao i
JOIN delegado ON delegado = matricula_delegado
JOIN crime c ON i.crime = cod_crime
ORDER BY nome_delegado;

--3. Criminosos e suas respectivas vitimas
SELECT  c.nome AS "Criminoso" ,v.nome AS "Vitima" FROM investigacao i
JOIN bo b ON i.numero_bo = b.numero_bo
JOIN criminoso c ON i.cpf_criminoso = c.cpf_criminoso
JOIN vitima v ON b.cpf_vitima = v.cpf_vitima
ORDER BY c.nome;

--2.3 Usando RIGHT JOIN para todos os dados da tabela crime serem exibidos e para os que estiverem na tabela investigacao, ser exibido o numero do B.O
SELECT c.descricao, i.numero_bo FROM investigacao i
RIGHT JOIN crime c ON c.cod_crime = i.crime;


-- 2.4 Duas consultas usando GROUP BY
-- 1. Mostrando a contagem de investigacao dos crimes que tenham sido investigado ao menos uma vez.
SELECT c.descricao, COUNT(i.numero_bo) AS total_investigacoes
FROM investigacao i
LEFT JOIN crime c ON c.cod_crime = i.crime
GROUP BY c.descricao;
--2. Mostrando a contagem de abertura de boletins dos agentes que tenham aberto ao menos 1 b.o
SELECT a.nome_agente AS Agente, COUNT(i.numero_bo) AS Ocorrencias
FROM investigacao i
LEFT JOIN bo b ON i.numero_bo = b.numero_bo
LEFT JOIN agente a ON b.matricula_agente = a.matricula_agente
GROUP BY a.nome_agente;



-- 2.5 Uma consulta usando alguma operação de conjunto (union, except ou  intersect)
-- Lista de pessoas envolvidas em investigações, indicando se são vítimas ou criminosos.
SELECT nome AS "Pessoa", 'Vítima' AS "Tipo"
FROM vitima
UNION
SELECT nome AS "Pessoa", 'Criminoso' AS "Tipo"
FROM criminoso;

--2.6 Duas consultas que usem subqueries. 
-- Nome dos Delegados cujo o Agente Joao Silva('1234567890') abriu o BO.
SELECT d.nome_delegado, i.numero_bo FROM investigacao i
JOIN bo b ON i.numero_bo = b.numero_bo
JOIN delegado d ON d.matricula_delegado = i.delegado
WHERE i.numero_bo IN (SELECT numero_bo FROM BO
				   	WHERE matricula_agente = '1234567890');
-- Nome dos delegados e o numero do protocolo das suas investigações, mas so daqueles com idade superior a 30 anos.			
SELECT d.nome_delegado, i.n_protocolo FROM investigacao i
JOIN delegado d ON i.delegado = d.matricula_delegado
WHERE d.idade IN(SELECT idade FROM delegado
				 WHERE idade > 30);





