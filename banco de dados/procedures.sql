-------------------------------- PROCEDURES ---------------------------------
----------------------- CRIANDO A PROCEDURE DA TABELA LOG -----------------------
-- PROCEDURE INSERT LOG
DELIMITER $$
CREATE PROCEDURE prc_log_insert(
	IN p_tipo_evento VARCHAR(50),
    IN p_id_usuario INT,
    IN p_detalhes VARCHAR(255),
    IN p_valores_old JSON,
    IN p_valores_new JSON
)
BEGIN
	INSERT INTO LOG (datetime_log, tipo_evento, id_usuario, detalhes, valores_old, valores_new)
	VALUES (NOW(), p_tipo_evento, p_id_usuario, p_detalhes, p_valores_old, p_valores_new);
END$$

DELIMITER ;
-- pra chamar a procedure use CALL insert_log('LOGIN', 'USUÁRIO REALIZOU O LOGIN', 1)

----------------------- CRIANDO AS PROCEDURES DA TABELA USUARIO -----------------------
-- ************** PROCEDURE INSERT USUARIO ************** --
DELIMITER $$
CREATE PROCEDURE prc_usuario_insert (
	IN p_nome VARCHAR(20),
    IN p_sobrenome VARCHAR(30),
    IN p_usuario VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_senha VARCHAR(30)
)
BEGIN
	DECLARE msg_erro VARCHAR(255);
    
    -- Verificando se já existe um usuário com esse nome de usuário
    IF EXISTS (SELECT 1 FROM USUARIO WHERE USUARIO = p_usuario) THEN
		SET msg_erro = 'Usuário já existe.';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
    END IF;
    
    -- Verificando se já existe um cadastro com esse email
    IF EXISTS (SELECT 1 FROM USUARIO WHERE EMAIL = p_email) THEN
		SET msg_erro = 'Email já cadastrado.';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
    END IF;
    
    -- Verificando o tamanho da senha (mínimo 6. máximo 30)
    IF LENGTH(p_senha) < 6 THEN
		SET msg_erro = 'Senha muito curta (mínimo 6 caracteres).';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
    END IF;
    
    -- Verificando o tamanho da senha (mínimo 6. máximo 30)
    IF LENGTH(p_senha) > 30 THEN
		SET msg_erro = 'Senha muito longa (máximo 30 caracteres).';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
    END IF;
    
    -- quando todas as validações forem realizadas, ele irá dar o insert padrão:
	INSERT INTO USUARIO (NOME, SOBRENOME, NOME_COMPLETO, USUARIO, EMAIL, SENHA)
    VALUES (p_nome, p_sobrenome, nome_completo(p_nome, p_sobrenome), p_usuario, p_email, p_senha);
    
    SELECT LAST_INSERT_ID() AS id;
END$$
DELIMITER ;

-- pra chamar a procedure use CALL insert_usuario('ryan', 'gabriel', 'ryangabriel01', 'ryan@gmail.com', '1234#@FD');

-- ************** PROCEDURE UPDATE USUARIO ************** --
DELIMITER $$
CREATE PROCEDURE prc_usuario_update (
	IN p_id INT,
    IN p_nome VARCHAR(20),
    IN p_sobrenome VARCHAR(30),
    IN p_usuario VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_senha VARCHAR(30)
)
BEGIN
	-- Criando as mesmas validações que criei na procedure de insert.
	DECLARE msg_erro VARCHAR(255);
    
    -- Verificando se já existe um usuário com esse id
    IF NOT EXISTS (SELECT 1 FROM USUARIO WHERE ID = p_id) THEN
		SET msg_erro = CONCAT('Usuário id ', p_id, ' não existe.');
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
    END IF;
    
    -- Verificando se já existe um usuário com esse nome de usuário
    IF EXISTS (SELECT 1 FROM USUARIO WHERE USUARIO = p_usuario) THEN
		SET msg_erro = 'Usuário já existe.';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
    END IF;
    
    -- Verificando se já existe um cadastro com esse email
    IF EXISTS (SELECT 1 FROM USUARIO WHERE EMAIL = p_email) THEN
		SET msg_erro = 'Email já cadastrado.';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
    END IF;
    
    -- Verificando o tamanho da senha (mínimo 6. máximo 30)
    IF LENGTH(p_senha) < 4 THEN
		SET msg_erro = 'Senha muito curta (mínimo 4 caracteres).';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
    END IF;
    
    -- Verificando o tamanho da senha (mínimo 6. máximo 30)
    IF LENGTH(p_senha) > 30 THEN
		SET msg_erro = 'Senha muito longa (máximo 30 caracteres).';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
    END IF;
    
    IF EXISTS(SELECT 1 FROM USUARIO WHERE ID = p_id AND ifnull(p_nome, nome) = nome AND ifnull(p_sobrenome, sobrenome) = sobrenome AND ifnull(p_usuario, usuario) = usuario and ifnull(p_email, email) = email and ifnull(p_senha, senha) = senha) THEN
		SET msg_erro = 'Nenhuma alteração foi realizada.';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
    END IF;
    
    -- quando todas as validações forem realizadas, ele irá dar o UPDATE:

	UPDATE USUARIO
    SET
		-- Aqui ele vai verificar se a informação está nula. Se o usuário enviar um valor, o campo será atualizado. Se mandar NULL, o campo permanece como está.
		NOME = IFNULL(p_nome, NOME),
		SOBRENOME = IFNULL(p_sobrenome, SOBRENOME),
        NOME_COMPLETO = nome_completo(NOME, SOBRENOME),
		USUARIO = IFNULL(p_usuario, USUARIO),
		EMAIL = IFNULL(p_email, EMAIL),
		SENHA = IFNULL(p_senha, SENHA)
    WHERE ID = p_id;
    
END$$

DELIMITER ;
-- Para rodar essa procedure de update, use isso: CALL update_usuario (1, null, null, 'ryangabriel02', null, 1234);


-- ************** PROCEDURE DELETE USUARIO ************** --
DELIMITER $$
CREATE PROCEDURE prc_usuario_delete (
	IN p_id INT
)
BEGIN
	DECLARE msg_erro VARCHAR(255);
    
    -- Verificando se existe um usuário com esse id
    IF NOT EXISTS (SELECT 1 FROM USUARIO WHERE ID = p_id) THEN
		SET msg_erro = CONCAT('Usuário id ', p_id, ' não existe.');
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
    END IF;

	DELETE FROM USUARIO
    WHERE ID = p_id;
END$$

DELIMITER ;
-- Para rodar: call delete_usuario(1);

----------------------- CRIANDO AS PROCEDURES DA TABELA MOV_PORTA -----------------------

-- ************** PROCEDURE INSERT MOV_PORTA ************** --
DELIMITER $$
CREATE PROCEDURE prc_mov_porta_insert (
	IN p_id_usuario_mov INT,
    IN p_status_porta char(1)
)
BEGIN
	DECLARE msg_erro VARCHAR(255);
    DECLARE p_tipo_mov VARCHAR(15);
    DECLARE ultimo_status CHAR(1);

    -- Verificando se o status retornado está certo
    IF p_status_porta not in ('A', 'F') THEN
		SET msg_erro = 'Status da porta só recebe dois valores: A ou F';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
    END IF;
    
    IF p_status_porta = 'A' THEN
		SET p_tipo_mov = 'Abriu a porta';
    END IF;
    
    IF p_status_porta = 'F' THEN
		SET p_tipo_mov = 'Fechou a porta';
    END IF;
    
    SELECT status_porta INTO ultimo_status
    FROM MOV_PORTA
    ORDER BY ID DESC
	LIMIT 1;
    
    IF ultimo_status = 'A' and p_status_porta = 'A' THEN
		SET msg_erro = 'A porta já está aberta.';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
	ELSEIF ultimo_status = 'F' and p_status_porta = 'F' THEN
		SET msg_erro = 'A porta já está fechada.';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg_erro;
	END IF;
    
    INSERT INTO MOV_PORTA (ID_USUARIO_MOV, TIPO_MOV, STATUS_PORTA, DATETIME_MOV)
    VALUES (p_id_usuario_mov, p_tipo_mov, p_status_porta, NOW());

END$$
DELIMITER ;