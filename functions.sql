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


