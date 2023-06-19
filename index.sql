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