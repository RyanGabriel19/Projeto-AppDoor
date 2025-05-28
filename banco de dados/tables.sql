----------------------- CRIANDO AS TABELAS -----------------------
create table USUARIO (
	ID int primary key auto_increment,
    NOME varchar(20) not null,
    SOBRENOME varchar(30) not null,
    NOME_COMPLETO VARCHAR(50) not null,
    USUARIO varchar(15) unique not null,
    EMAIL varchar(100) unique not null,
    SENHA varchar (30) not null
	);

create table MOV_PORTA (
	ID int primary key auto_increment,
    ID_USUARIO_MOV int not null,
    TIPO_MOV varchar(15) not null,
    STATUS_PORTA CHAR(1) not null,
    DATETIME_MOV datetime not null,
    check (STATUS_PORTA in ('A', 'F'))
);

CREATE TABLE LOG (
  id INT AUTO_INCREMENT PRIMARY KEY,
  datetime_log DATETIME NOT NULL,
  tipo_evento VARCHAR(50) NOT NULL,
  id_usuario INT,
  detalhes TEXT NOT NULL,
  valores_old JSON,
  valores_new JSON
  -- foreign key (id_usuario) references USUARIO(ID)
);
-- ---------------------------------------------------------------- --