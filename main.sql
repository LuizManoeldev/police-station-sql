-- Criação das tabelas
CREATE TABLE crime (
	cod_crime INT NOT NULL,
	descricao VARCHAR(100),
	pena_crime VARCHAR(30) 
);

CREATE TABLE criminoso (
	cpf_criminoso VARCHAR(14) CHECK (cpf_criminoso ~ '^([0-9]{3}\.){2}[0-9]{3}-[0-9]{2}$') NOT NULL,
	nome VARCHAR(50),
	telefone_familia VARCHAR(11)
);

CREATE TABLE endereco (
	cep VARCHAR(8) CHECK (CEP ~ '^[0-9]{8}$'),
	rua VARCHAR(50)
);

CREATE TABLE delegado (
	matricula_delegado VARCHAR(10) NOT NULL,
	nome_delegado VARCHAR(50),
	idade INT,
	telefone VARCHAR(11),
	endereco VARCHAR(8)
);

CREATE TABLE agente (
	matricula_agente VARCHAR(12) NOT NULL,
	nome_agente VARCHAR(50),
	idade INT,
	telefone VARCHAR(11),
	endereco VARCHAR(8)
);

CREATE TABLE vitima (
	cpf_vitima VARCHAR(14) CHECK (cpf_vitima ~ '^([0-9]{3}\.){2}[0-9]{3}-[0-9]{2}$') NOT NULL,
	nome VARCHAR(50),
	telefone VARCHAR(11)
);

CREATE TABLE BO (
	numero_bo SERIAL NOT NULL,
	data_ocorrencia DATE,
	relato VARCHAR(100),
	cpf_vitima VARCHAR(14) CHECK (cpf_vitima ~ '^([0-9]{3}\.){2}[0-9]{3}-[0-9]{2}$'),
	matricula_agente VARCHAR(10)
);

CREATE TABLE investigacao (
	n_protocolo SERIAL NOT NULL,
	exito BOOLEAN,
	cpf_criminoso VARCHAR(14) CHECK (cpf_criminoso ~ '^([0-9]{3}\.){2}[0-9]{3}-[0-9]{2}$'),
	crime INT NOT NULL,
	delegado VARCHAR(10) NOT NULL,
	numero_bo INT NOT NULL
);

CREATE TABLE backup_criminal (
 	id SERIAL PRIMARY KEY,
 	cpf_criminoso VARCHAR(14) CHECK (cpf_criminoso ~ '^([0-9]{3}\.){2}[0-9]{3}-[0-9]{2}$') NOT NULL,
	nome VARCHAR(50)

);

-- CONSTRAINTS DE CHAVES PRIMARIAS
ALTER TABLE crime ADD CONSTRAINT PK_Crime PRIMARY KEY (cod_crime);
ALTER TABLE criminoso ADD CONSTRAINT PK_Criminoso PRIMARY KEY (cpf_criminoso);
ALTER TABLE endereco ADD CONSTRAINT PK_Endereco PRIMARY KEY (cep);
ALTER TABLE delegado ADD CONSTRAINT PK_Delegado PRIMARY KEY (matricula_delegado);
ALTER TABLE agente ADD CONSTRAINT PK_Agente PRIMARY KEY (matricula_agente);
ALTER TABLE vitima ADD CONSTRAINT PK_Vitima PRIMARY KEY (cpf_vitima);
ALTER TABLE BO ADD CONSTRAINT PK_BO PRIMARY KEY (numero_bo);
ALTER TABLE investigacao ADD CONSTRAINT PK_INVESTIGACAO PRIMARY KEY (n_protocolo);

-- CONSTRAINTS DE CHAVES ESTRANGEIRAS
ALTER TABLE delegado ADD CONSTRAINT FK_Delegado FOREIGN KEY (endereco) REFERENCES endereco (cep);
ALTER TABLE agente ADD CONSTRAINT FK_Agente_ENDERECO FOREIGN KEY (endereco) REFERENCES endereco (cep);
ALTER TABLE BO ADD CONSTRAINT FK_BO_VITIMA FOREIGN KEY (cpf_vitima) REFERENCES vitima(cpf_vitima);
ALTER TABLE BO ADD CONSTRAINT FK_BO_AGENTE FOREIGN KEY (matricula_agente) REFERENCES agente(matricula_agente);
ALTER TABLE investigacao ADD CONSTRAINT FK_INV_CRIMINOSO FOREIGN KEY (cpf_criminoso) REFERENCES criminoso(cpf_criminoso);
ALTER TABLE investigacao ADD CONSTRAINT FK_INV_CRIME FOREIGN KEY (crime) REFERENCES crime(cod_crime);
ALTER TABLE investigacao ADD CONSTRAINT FK_INV_BO FOREIGN KEY (numero_bo) REFERENCES BO(numero_bo);




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


----------------------------------------------------------------------------------------------------------------------------
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
SELECT i.n_protocolo AS "Caso", d.nome_delegado AS "Delegado do Caso", a.nome_agente AS "Agente do Caso" 
FROM investigacao i
JOIN delegado d ON i.delegado = d.matricula_delegado
JOIN bo b ON i.numero_bo = b.numero_bo
JOIN agente a ON a.matricula_agente = b.matricula_agente
ORDER BY i.n_protocolo;



----------------------------------------------------------------------------------------------------------------------------
-- Index
-- Numa delegacia ocorrem muitas investigações, um indice criado na chave primaria da tabela, ira acelerar a consulta
CREATE INDEX idx_investigacao
ON investigacao(n_protocolo);

-- Diversos criminosos sao cadastrados em uma delegacia, ao contrario do nome, o cpf de um crimnoso nao pode se repitir, portanto o indice deve ser criado com o cpf
CREATE INDEX idx_criminoso
ON criminoso(cpf_criminoso);

-- Agentes podem abrir diversos BO, uma consulta buscando saber os b.o abertos por um agente pode ser necessaria
CREATE INDEX idx_agente
ON bo(matricula_agente);



----------------------------------------------------------------------------------------------------------------------------
-- Reescrita de consultas
--Antiga
SELECT d.nome_delegado, i.numero_bo FROM investigacao i
JOIN bo b ON i.numero_bo = b.numero_bo
JOIN delegado d ON d.matricula_delegado = i.delegado
WHERE i.numero_bo IN (SELECT numero_bo FROM BO
				   	WHERE matricula_agente = '1234567890');
-- Nova
SELECT d.nome_delegado, i.numero_bo
FROM investigacao i
JOIN bo b ON i.numero_bo = b.numero_bo AND b.matricula_agente = '1234567890'
JOIN delegado d ON d.matricula_delegado = i.delegado;

-- Antiga
SELECT d.nome_delegado, i.n_protocolo FROM investigacao i
JOIN delegado d ON i.delegado = d.matricula_delegado
WHERE d.idade IN(SELECT idade FROM delegado
				 WHERE idade > 30);
-- Nova
SELECT d.nome_delegado, i.n_protocolo
FROM investigacao i
JOIN delegado d ON i.delegado = d.matricula_delegado AND d.idade > 30;



----------------------------------------------------------------------------------------------------------------------------
--Funções/Procedures  Armazenadas

-- 1. Procedure para gerar BO.	
CREATE OR REPLACE PROCEDURE gerar_boletim_ocorrencia(
    p_data_ocorrencia DATE,
	p_relato VARCHAR,
	p_matricula_agente VARCHAR,
    p_cpf_vitima VARCHAR,
	p_nome_vitima VARCHAR,
	p_telefone_vitima VARCHAR
)
AS $$
BEGIN
	-- Inserir primeiramente na tabela vitimas
	INSERT INTO vitima(cpf_vitima, nome, telefone)
	VALUES (p_cpf_vitima, p_nome_vitima, p_telefone_vitima);
    -- Inserir os dados do B.O. na tabela BO
	INSERT INTO BO(data_ocorrencia, relato, cpf_vitima, matricula_agente)
    VALUES (p_data_ocorrencia, p_relato, p_cpf_vitima, p_matricula_agente);
    
	
	-- Exibir mensagem de sucesso
    RAISE NOTICE 'B.O. gerado com sucesso.';
    EXCEPTION
        WHEN OTHERS THEN
         	-- Capturar a exceção e exibir mensagem de erro
            RAISE EXCEPTION 'Erro ao gerar o B.O.: %', SQLERRM;

END;
$$ LANGUAGE PLPGSQL;


-- 2. Delegado do Mes (Funcao Armazenada com COUNT)
CREATE OR REPLACE FUNCTION delegado_do_mes()
RETURNS void AS $$
declare
	delegadodomes VARCHAR(50);
	exitos BIGINT;
BEGIN
 
    SELECT nome_delegado AS "Delegado do Mes" , COUNT(*) AS exitos
    FROM investigacao  JOIN delegado d on delegado = matricula_delegado
    WHERE exito = TRUE
    GROUP BY nome_delegado
    ORDER BY exitos DESC
    LIMIT 1 INTO delegadodomes, exitos;
	
	raise notice 'O delegado do Mes foi: %', delegadodomes;
	raise notice 'Com % exitos.', exitos;
END;
$$ LANGUAGE plpgsql;


-- 3. Finalizar Investigacao ((Funcao Armazenada 1)
CREATE OR REPLACE FUNCTION finalizar_investigacao(
	p_protocolo INT,
	p_exito BOOLEAN,
	p_cpf_criminoso VARCHAR DEFAULT NULL,
	p_nome_criminoso VARCHAR DEFAULT NULL,
	p_telefone_familia VARCHAR DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
	-- Em casa de sucesso na investigacao, é encerrado com exito e com o cpf do infrator
	IF(p_exito = true) THEN
		
		INSERT INTO CRIMINOSO(cpf_criminoso, nome, telefone_familia) VALUES
		(p_cpf_criminoso, p_nome_criminoso, p_telefone_familia);
		
		UPDATE investigacao
    	SET exito = p_exito, cpf_criminoso = p_cpf_criminoso
    	WHERE n_protocolo = p_protocolo;
	ELSE
		UPDATE investigacao
		SET exito = p_exito
		WHERE n_protocolo = p_protocolo;
	END IF;
    -- Exibir mensagem de sucesso
    RAISE NOTICE 'Investigação encerrada com sucesso. Protocolo: %', p_protocolo;
END;
$$ LANGUAGE plpgsql;


-- 4. Iniciar Investigacao (Funcao Armazenada 2)
CREATE OR REPLACE FUNCTION iniciar_investigacao(
    p_crime INT,
	p_delegado VARCHAR,
    p_numero_bo INT
)
RETURNS VOID AS $$
BEGIN
    -- Inserir os dados do B.O. na tabela BO
	INSERT INTO investigacao (exito,cpf_criminoso, crime,delegado, numero_bo)
    VALUES (null,null, p_crime, p_delegado, p_numero_bo);
    -- Exibir mensagem de sucesso
    RAISE NOTICE 'Investigação para codigo % iniciada.', p_crime;
    EXCEPTION
        WHEN OTHERS THEN
         	-- Capturar a exceção e exibir mensagem de erro
            RAISE EXCEPTION 'Erro ao iniciar investigacao.: %', SQLERRM;

END;
$$ LANGUAGE PLPGSQL;




----------------------------------------------------------------------------------------------------------------------------
--Triggers

-- 1.  Trigger que permite a inserção a partir de uma view
-- Funcao para realizar as inserções
CREATE OR REPLACE FUNCTION inserir_investigacao()
RETURNS TRIGGER AS
$$
BEGIN
    -- Inserir os dados do B.O. na tabela BO
	INSERT INTO investigacao (exito,cpf_criminoso, crime,delegado, numero_bo)
    VALUES (null,null, p_crime, p_delegado, p_numero_bo);
    -- Exibir mensagem de sucesso
    RAISE NOTICE 'Investigação para codigo % iniciada.', p_crime;
    EXCEPTION
        WHEN OTHERS THEN
         	-- Capturar a exceção e exibir mensagem de erro
            RAISE EXCEPTION 'Erro ao iniciar investigacao.: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;

-- Criação do trigger associado à view "vw_investigacao" que permite a inserção na mesma.
CREATE TRIGGER tg_inserir_investigacao
INSTEAD OF INSERT ON vw_investigacao
FOR EACH ROW
EXECUTE FUNCTION inserir_investigacao();




-- 2. Trigger para fazer um backup da ficha criminal dos criminosos liberados para posteriores consultas
CREATE OR REPLACE FUNCTION backup_infratores()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO backup_criminal(cpf_criminoso, nome)
  VALUES (OLD.cpf_criminoso, OLD.nome);
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_backup
AFTER DELETE ON criminoso
FOR EACH ROW
EXECUTE FUNCTION backup_infratores();


-- 3. Criacao de um trigger para caso um crime sofra alterao no artigo penal, o valor seja alterado em todas as outras tabelas
-- Criação da função de trigger
CREATE OR REPLACE FUNCTION atualizar_crime()
RETURNS TRIGGER AS
$$
BEGIN
    -- Atualiza os dados nas outras tabelas
    UPDATE investigacao SET crime = NEW.valor WHERE chave = NEW.chave;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

-- Criação do trigger associado a tabela crime, que sera acioanado apos um UPDATE
CREATE TRIGGER tr_atualizar_crime
AFTER UPDATE ON crime
FOR EACH ROW
EXECUTE FUNCTION atualizar_crime();



----------------------------------------------------------------------------------------------------------------------------
-- Inserindo Dados 

-- Tablea de Enderecos
INSERT INTO endereco (CEP, Rua)
VALUES
    ('12345678', 'Rua Augusta'),
    ('87654321', 'Avenida Brasil'),
    ('98765432', 'Rua da Consolação'),
    ('23456789', 'Rua Oscar Freire'),
    ('34567890', 'Avenida Paulista'),
    ('45678901', 'Rua Padre João Manoel'),
    ('56789012', 'Avenida Tiradentes'),
    ('67890123', 'Rua Haddock Lobo'),
    ('78901234', 'Rua Augusta'),
    ('89012345', 'Rua Alfredo de Lima'),
    ('90123456', 'Rua Coronel Francisco'),
    ('01234567', 'Rua Epitacio Pessoa');
  

-- Tabela Delegado
INSERT INTO delegado (matricula_delegado, nome_delegado, idade, telefone, endereco) VALUES
    ('0987654321', 'Maria Santos', 30, '8888888888', '67890123'), 
    ('1357924680', 'Pedro Souza', 35, '7777777777', '67890123'),
    ('2468135790', 'Ana Lima', 28, '6666666666', '45678901'),
    ('9876543210', 'Lucas Almeida', 32, '5555555555', '34567890'),
    ('0123456789', 'Juliana Pereira', 27, '4444444444', '90123456'),
    ('1029384756', 'Rafaela Oliveira', 31, '3333333333', '45678901'),
    ('9876543211', 'Fernando Costa', 29, '2222222222', '34567890');


-- Tabela Agente
INSERT INTO agente (matricula_agente, nome_agente, idade, telefone, endereco) VALUES
    ('1234567890', 'João Silva', 25, '64852348594', '01234567'),
    ('9876543210', 'Maria Souza', 30, '23594528452', '23456789'), 
    ('4567890123', 'Pedro Santos', 35, '36458965985', '56789012'), 
    ('7890123456', 'Ana Oliveira', 40, '32698548953', '56789012'), 
    ('2345678901', 'Carlos Pereira', 22, '36514852369', '01234567'), 
    ('6789012345', 'Lúcia Mendes', 27, '34566845215', '89012345'),
    ('3456789012', 'Mariana Castro', 33, '03546984521', '90123456'),
    ('9012345678', 'Paulo Fernandes', 28, '03587425369', '56789012');



-- Tabela Crime

INSERT INTO crime (cod_crime, descricao, pena_crime) VALUES
    (121, 'Roubo qualificado', '4 a 10 anos de reclusão'),
    (211, 'Homicídio doloso', '6 a 20 anos de reclusão'),
    (312, 'Falsidade ideológica', '2 a 6 anos de reclusão'),
    (444, 'Estupro', '8 a 12 anos de reclusão'),
    (503, 'Corrupção ativa', '2 a 12 anos de reclusão'),
    (631, 'Tráfico de drogas', '5 a 15 anos de reclusão'),
    (712, 'Crime de extorsão', '3 a 10 anos de reclusão'),
    (811, 'Apropriação indébita', '1 a 4 anos de reclusão'),
    (932, 'Crimes contra o patrimônio', '2 a 8 anos de reclusão'),
    (105, 'Crime de injúria', '1 a 6 meses de detenção'),
    (227, 'Lesão corporal grave', '1 a 5 anos de reclusão'),
    (342, 'Furto qualificado', '2 a 8 anos de reclusão'),
    (417, 'Associação criminosa', '1 a 3 anos de reclusão'),
    (508, 'Crime de corrupção passiva', '2 a 12 anos de reclusão'),
    (619, 'Homicídio culposo', '1 a 4 anos de detenção'),
    (714, 'Falsificação de documento', '2 a 6 anos de reclusão'),
    (829, 'Estelionato', '1 a 5 anos de reclusão'),
    (939, 'Rixa', '6 meses a 2 anos de detenção'),
    (101, 'Difamação', '3 meses a 1 ano de detenção'),
    (255, 'Ameaça', '1 a 6 meses de detenção'),
	(111, 'Ameaça com emprego de arma', '2 a 5 anos de reclusão'),
    (235, 'Furto simples', '1 a 4 anos de reclusão'),
    (421, 'Homicídio culposo na direção de veículo automotor', '2 a 4 anos de detenção'),
    (529, 'Crime de falsificação de documento público', '2 a 6 anos de reclusão'),
    (639, 'Tráfico de drogas privilegiado', '1 a 4 anos de reclusão'),
    (751, 'Furto qualificado pelo concurso de pessoas', '2 a 8 anos de reclusão'),
    (813, 'Estupro de vulnerável', '8 a 15 anos de reclusão'),
    (923, 'Crimes contra a honra', '3 meses a 2 anos de detenção'),
    (104, 'Dano ao patrimônio público', '6 meses a 3 anos de detenção'),
    (157, 'Roubo simples', '4 a 10 anos de reclusão');


-- Gerando todos os Boletins de ocorrencia

CALL gerar_boletim_ocorrencia('2022-08-17','Estprou a vizinha','7890123456','987.654.321-10', 'Larissa Silva', '02123456789'); 
CALL gerar_boletim_ocorrencia('2023-05-17','Assalto a Mao Armada','1234567890','901.234.567-07', 'Paulo Fernandes', '01890123456' ); 
CALL gerar_boletim_ocorrencia('2022-12-29','Estupro de uma crianca', '1234567890','432.109.876-08', 'Laura Costa', '01901234567'); 
CALL gerar_boletim_ocorrencia('2023-08-03','Ameaca de Morte com arma', '1234567890', '345.678.901-06', 'Mariana Castro', '01789012345'); 
CALL gerar_boletim_ocorrencia('2022-09-21','Constantes Ameaças','9876543210','678.901.234-05', 'Lúcia Mendes', '01678901234'); 
CALL gerar_boletim_ocorrencia('2023-02-10','Constantes publicações difamatorias','4567890123','234.567.890-04', 'Carlos Pereira', '01567890123'); 
CALL gerar_boletim_ocorrencia('2022-11-14','Furto de Caixa Eletronico','4567890123','876.543.210-09', 'Fernando Almeida', '02012345678'); 
CALL gerar_boletim_ocorrencia('2023-07-07','Pichação de muro residencial','2345678901','789.012.345-03', 'Ana Oliveira', '01456789012'); 
CALL gerar_boletim_ocorrencia('2022-10-01','Assasinato do Social','9012345678','456.789.012-02', 'Pedro Santos', '01345678901'); 
CALL gerar_boletim_ocorrencia('2023-03-26','Assalto a carro forte','7890123456','987.654.321-01', 'Maria Souza', '01234567890'); 


-- Iniciando Investigações

select iniciar_investigacao(157,'0987654321',1);
select iniciar_investigacao(813,'1357924680',2);
select iniciar_investigacao(111,'0987654321',3);
select iniciar_investigacao(255,'1357924680',4);
select iniciar_investigacao(101,'2468135790',5);
select iniciar_investigacao(342,'9876543210',6);
select iniciar_investigacao(932,'0987654321',7);
select iniciar_investigacao(211,'9876543210',8);
select iniciar_investigacao(121,'0123456789',9);
select iniciar_investigacao(444,'0987654321',10);

-- Encerrando Investigações

select finalizar_investigacao(1,TRUE, '654.321.098-11', 'Ricardo Souza', '02234567890');--
select finalizar_investigacao(2,TRUE,'987.654.321-12', 'Amanda Santos', '02345678901');
select finalizar_investigacao(3, TRUE,'321.098.765-13', 'Rafael Oliveira', '02456789012');--
select finalizar_investigacao(4,FALSE);
select finalizar_investigacao(5, FALSE);
select finalizar_investigacao(6,FALSE);
select finalizar_investigacao(7, TRUE,'098.765.432-17', 'Lorena Fernandes', '02890123456');--
select finalizar_investigacao(8,TRUE, '543.210.987-18', 'Mariana Costa', '02901234567');
select finalizar_investigacao(9, TRUE,'098.765.432-19', 'Ricardo Almeida', '03012345678');
select finalizar_investigacao(10, FALSE);

