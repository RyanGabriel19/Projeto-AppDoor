import jwt from 'jsonwebtoken';

import {
  selectUsuarios,
  buscarUsuarios,
  insertUsuarios,
  updateUsuarios,
  deletarUsuarios,
  buscarUsuariosPorId 
} from "../models/usuarioModel.js"

//////////////////////////////////////////////////////////////////////////////////////////
//Função para retornar o perfil do usuário logado
export async function getPerfilUsuario(req, res) {
  try {
    console.log('req.usuario recebido no perfil:', req.usuario);
    const usuarioId = req.usuario.id;
    const usuario = await buscarUsuariosPorId(usuarioId);

    if (!usuario) {
      return res.status(404).json({ error: 'Usuário não encontrado.' });
    }

    const resposta = {
      id: usuario.ID,
      usuario: usuario.USUARIO,
      nome: usuario.NOME,
      email: usuario.EMAIL
    };

    console.log('Enviando perfil para o Flutter:', resposta);

    // O RETURN GARANTE o envio da resposta
    return res.status(200).json(resposta);
  } catch (err) {
    console.error('Erro ao buscar perfil:', err);
    return res.status(500).json({ error: 'Erro interno.' });
  }
}
///////////////////////////////////////////////////////////////////////////////////////

export async function getUsuarios(req, res) {
  try {
    const usuarios = await selectUsuarios();
    res.status(200).json(usuarios);
  } catch (err) {
    console.error('Erro ao buscar usuários:', err);
    res.status(500).json({ error: 'Erro ao buscar usuários.' });
  }
}

///////////////////////////////////////////////////////////////////////////////////////
//gera o token para acessar as informacoes do usuario logado

const SECRET_KEY = 'ryan123'
export async function postUsuariosLogin(req, res) {
  const { email, senha } = req.body
  try {
    const usuario = await buscarUsuarios(email);

    if (!usuario) {
      return res.status(401).json({ error: 'Usuário não encontrado.' });
    }

    if (usuario.senha !== senha) {
      return res.status(401).json({ error: 'Senha incorreta.' });
    }
    const token = jwt.sign(
      {id: usuario.id, nome: usuario.nome, usuario: usuario.usuario, email: usuario.email}, SECRET_KEY,
      {expiresIn: '1h'}
    );
    res.status(200).json({message: 'Login realizado com sucesso.', token});
  } catch (err) {
    console.error('Erro ao realizar o login:', err);
    res.status(500).json({ error: 'Erro ao realizar o login.' });
  }
}

///////////////////////////////////////////////////////////////////////////////////////
//funcao para cadastro de usuario
export async function postUsuarios(req, res) {
  const { nome, sobrenome, usuario, email, senha } = req.body;
  try {
    const id = await insertUsuarios(nome, sobrenome, usuario, email, senha)
    return res.status(201).json({ id, message: `Usuário ${usuario} cadastrado com sucesso.` });
  } catch (err) {
    console.error('Erro na procedure insert_usuario:', err);

    // Erro customizado via SIGNAL SQLSTATE '45000'
    if (err.sqlState === '45000') {
      return res.status(400).json({ error: err.sqlMessage });
    }

    // Falha geral
    return res.status(500).json({ error: 'Erro interno no banco de dados' });
  }
}

///////////////////////////////////////////////////////////////////////////////////////

export async function putUsuarios(req, res) {
  const { id } = req.params; // ID deve vir na URL
  const { nome, sobrenome, usuario, email, senha } = req.body;

  try {
    await updateUsuarios(id, nome, sobrenome, usuario, email, senha)
    return res.status(200).json({
      id: Number(id),
      message: `Usuário ID ${id} atualizado com sucesso.`,
    });
  } catch (err) {
    console.error('Erro na procedure update_usuario:', err);

    if (err.sqlState === '45000') {
      return res.status(400).json({ error: err.sqlMessage });
    }

    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ error: err.sqlMessage });
    }

    return res.status(500).json({ error: 'Erro interno no banco de dados' });
  }
}


///////////////////////////////////////////////////////////////////////////////////////

export async function deleteUsuarios(req, res) {
  const { id } = req.params;
  try {
    await deletarUsuarios(id)
    return res.status(200).json({
      id: Number(id),
      message: `Usuário ID ${id} removido com sucesso.`
    });
  } catch (err) {
    console.error('Erro ao deletar usuário:', err);

    if (err.sqlState === '45000') {
      return res.status(400).json({ error: err.sqlMessage });
    }

    return res.status(500).json({ error: 'Erro interno ao deletar usuário' });
    // ou(err);
  }
}


///////////////////////////////////////////////////////////////////////////////////////