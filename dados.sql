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