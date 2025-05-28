----------------------- CRIANDO AS TRIGGERS DE INSERT NO LOG -----------------------
-- TABELA USUARIO
-- ************** LOG INSERT USUARIO ************** --
DELIMITER $$
CREATE TRIGGER trg_usuario_after_insert
AFTER INSERT ON USUARIO
FOR EACH ROW
BEGIN

	CALL prc_log_insert (
		'INSERT',
		NEW.ID,
		CONCAT('Usuário ', NEW.USUARIO, ' cadastrado com sucesso.'),
        null,
		JSON_OBJECT('id', NEW.ID,
				'nome', NEW.NOME,
				'sobrenome', NEW.SOBRENOME,
				'usuario', NEW.USUARIO,
				'email', NEW.EMAIL,
                'senha', NEW.SENHA)
    );

END$$
DELIMITER ;

-- ************** LOG UPDATE USUARIO ************** --
DELIMITER $$
CREATE TRIGGER trg_usuario_after_update
AFTER UPDATE ON USUARIO
FOR EACH ROW
BEGIN
	DECLARE atualizacao TEXT DEFAULT '';
	
	-- comparar e concatenar cada mudança
	IF OLD.NOME <> NEW.NOME THEN
		SET atualizacao = CONCAT(atualizacao,
		  'nome: "', OLD.NOME, '" → "', NEW.NOME, '"; ');
	END IF;
	IF OLD.SOBRENOME <> NEW.SOBRENOME THEN
		SET atualizacao = CONCAT(atualizacao,
		  'sobrenome: "', OLD.SOBRENOME, '" → "', NEW.SOBRENOME, '"; ');
	END IF;
	IF OLD.USUARIO <> NEW.USUARIO THEN
		SET atualizacao = CONCAT(atualizacao,
		  'usuario: "', OLD.USUARIO, '" → "', NEW.USUARIO, '"; ');
	END IF;
    IF OLD.EMAIL <> NEW.EMAIL THEN
		SET atualizacao = CONCAT(atualizacao,
		  'email: "', OLD.EMAIL, '" → "', NEW.EMAIL, '"; ');
	END IF;
    IF OLD.SENHA <> NEW.SENHA THEN
		SET atualizacao = CONCAT(atualizacao,
		  'senha: "', OLD.SENHA, '" → "', NEW.SENHA, '"; ');
	END IF;

	CALL prc_log_insert (
        'UPDATE',
        NEW.ID,
        atualizacao,
        JSON_OBJECT('id', OLD.ID,
				'nome', OLD.NOME,
				'sobrenome', OLD.SOBRENOME,
				'usuario', OLD.USUARIO,
				'email', OLD.EMAIL,
                'senha', OLD.SENHA),
		JSON_OBJECT('id', NEW.ID,
				'nome', NEW.NOME,
				'sobrenome', NEW.SOBRENOME,
				'usuario', NEW.USUARIO,
				'email', NEW.EMAIL,
                'senha', NEW.SENHA)
    );

END$$
DELIMITER ;

-- ************** LOG DELETE USUARIO ************** --
DELIMITER $$
CREATE TRIGGER trg_usuario_after_delete
AFTER DELETE ON USUARIO
FOR EACH ROW
BEGIN
	CALL prc_log_insert (
			'DELETE',
			OLD.ID,
			CONCAT('Usuário ', OLD.USUARIO, ' deletado com sucesso.'),
			JSON_OBJECT('id', OLD.ID,
					'nome', OLD.NOME,
					'sobrenome', OLD.SOBRENOME,
					'usuario', OLD.USUARIO,
					'email', OLD.EMAIL,
					'senha', OLD.SENHA),
			JSON_OBJECT('id', null,
					'nome', null,
					'sobrenome', null,
					'usuario', null,
					'email', null,
					'senha', null)
		);
END $$
DELIMITER ;



-- ******************************************************************************** --
-- TABELA MOV_PORTA
-- ************** LOG INSERT MOV_PORTA ************** --
DELIMITER $$
CREATE TRIGGER trg_mov_porta_insert
AFTER INSERT ON MOV_PORTA
FOR EACH ROW
BEGIN
	DECLARE detalhes TEXT;
    
    IF (NEW.STATUS_PORTA = 'A') THEN
		SET detalhes = CONCAT('Usuário ID ', NEW.ID_USUARIO_MOV, ' abriu a porta.');
	END IF;
    IF (NEW.STATUS_PORTA = 'F') THEN
		SET detalhes = CONCAT('Usuário ID ', NEW.ID_USUARIO_MOV, ' fechou a porta.');
	END IF;

	CALL prc_log_insert(
        'INSERT',
        NEW.ID_USUARIO_MOV,
        detalhes,
        null,
        JSON_OBJECT(
			'id_usuario_mov', NEW.ID_USUARIO_MOV,
            'tipo_mov', NEW.TIPO_MOV,
            'status_porta', NEW.STATUS_PORTA,
            'datetime_mov', NEW.DATETIME_MOV
        )
    );
    
END $$
DELIMITER ;
-- ******************************************************************************** --