DELIMITER //
CREATE PROCEDURE sp_insert_curso (n_curso VARCHAR(30) , cod_depart INT(4), OUT resultado VARCHAR(50))
BEGIN
	
    -- Declarando Váriaveis
    DECLARE validacao_curso VARCHAR(50);
    DECLARE erro_existe VARCHAR(50);
    DECLARE erro_nulo VARCHAR(50);
    DECLARE erro_branco VARCHAR(50);
    DECLARE erro_numero VARCHAR(50);
    DECLARE resultado_erro VARCHAR(50);
    DECLARE cadastro_realizado VARCHAR(50);
    
    -- Setando valores das váriaveis 
    SET erro_existe = ('O curso já está cadastrado!');
    SET erro_nulo = ('O nome não pode ser nulo!');
    SET erro_branco = ('O campo nome_curso não pode ser em branco!');
    SET erro_numero = ('Não são permitidos números!');
    SET cadastro_realizado = ('Cadastro realizado com sucesso!');
	SET validacao_curso = (SELECT nome_curso FROM curso WHERE nome_curso = n_curso);
    
    START TRANSACTION;
    -- Tratando Dados (Curso existente)
    IF (validacao_curso = n_curso) THEN		
		ROLLBACK; # desfaz a transação
        SET resultado = erro_existe;		
        SELECT resultado;
        -- Tratando Dados (Curso com o campo nome_curso nulo)
		ELSE IF(n_curso IS NULL) THEN					
			ROLLBACK; # desfaz a transação
            SET resultado = erro_nulo;	
            SELECT resultado;
        -- Tratando Dados (Curso com o campo nome_curso em branco) 
		ELSEIF (n_curso = '') THEN
			ROLLBACK; # desfaz a transação
            SET resultado = erro_existe;	
            SELECT resultado;
            SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "Não foi possível realizar a inserção do dado!";
        -- Tratando Dados (Curso com o campo nome com números)
		ELSEIF (n_curso LIKE '%0%') OR (n_curso LIKE '%1%') OR (n_curso LIKE '%2%') OR (n_curso LIKE '%3%') OR (n_curso LIKE '%4%') OR (n_curso LIKE '%5%') OR (n_curso LIKE '%6%') OR (n_curso LIKE '%7%') OR (n_curso LIKE '%8%') OR (n_curso LIKE '%9%') THEN            
			ROLLBACK; # desfaz a transação
            SET resultado = erro_numero;
            SELECT resultado;
            SIGNAL SQLSTATE "45000" SET MESSAGE_TEXT = "Não são permitidos números nos nomes!";
		ELSE 
			INSERT INTO curso (nome_curso, cod_departamento) VALUES (FN_primeira_maiuscula(n_curso), cod_depart);
			COMMIT;
            SELECT cadastro_realizado;
		END IF;
    END IF; 
    
END //
DELIMITER ;

DROP PROCEDURE sp_insert_curso;
CALL sp_insert_curso ('portugues', '1000', @resultado);

SELECT * FROM curso;