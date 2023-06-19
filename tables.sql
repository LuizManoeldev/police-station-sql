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


