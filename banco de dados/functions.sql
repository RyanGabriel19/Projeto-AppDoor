----------------------- CRIANDO AS FUNÇÕES -----------------------
-- CALCULAR NOME COMPLETO
DELIMITER $$

CREATE FUNCTION nome_completo (f_nome VARCHAR(20), f_sobrenome VARCHAR(30))
RETURNS VARCHAR(51)
DETERMINISTIC
BEGIN
	RETURN CONCAT(f_nome, ' ', f_sobrenome);
END$$

DELIMITER ;

