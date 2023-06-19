-- Views
-- 1. View para Inserção
CREATE VIEW vw_investigacao AS
SELECT *
FROM investigacao;

-- 2. View Robusta
-- View mostrando o nome do Infrator, a descricao do crime que cometeu e o nome da vitima
CREATE VIEW vw_criminososevitimas AS
SELECT  c.nome AS "Criminoso" ,cr.descricao AS "Cometeu", v.nome AS "Vitima" FROM investigacao i
JOIN crime cr ON i.crime = cr.cod_crime
JOIN bo b ON i.numero_bo = b.numero_bo
JOIN criminoso c ON i.cpf_criminoso = c.cpf_criminoso
JOIN vitima v ON b.cpf_vitima = v.cpf_vitima;

-- 3. View Robusta
-- View mostrando o nome do delegado e o nome do agente responsaveis pelo caso.
CREATE VIEW vw_investigadores AS
SELECT d.nome_delegado AS "Delegado do Caso", a.nome_agente AS "Agente do Caso"
FROM investigacao i
JOIN delegado d ON i.delegado = d.matricula_delegado
JOIN bo b ON i.numero_bo = b.numero_bo
JOIN agente a ON a.matricula_agente = b.matricula_agente;

