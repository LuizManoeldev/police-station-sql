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
  INSERT INTO backup_criminal(cpf, nome)
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





