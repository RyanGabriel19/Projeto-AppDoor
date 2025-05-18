import { db } from "../config/db.js";

///////////////////////////////////////////////////////////////////////////////////////

export async function getUsuarios(req, res) {
  try {
    const [rows] = await db.query('SELECT * FROM USUARIO');
    res.status(200).json(rows);
  } catch (err) {
    console.error('Erro ao buscar usuários:', err);
    res.status(500).json({ error: 'Erro ao buscar usuários.' });
  }
}

///////////////////////////////////////////////////////////////////////////////////////

export async function postUsuarios(req, res) {
  const { nome, sobrenome, usuario, email, senha } = req.body;
  try {
    const [inserir] = await db.execute(
      `CALL prc_usuario_insert(?, ?, ?, ?, ?)`, [nome, sobrenome, usuario, email, senha]
    );
    const id = inserir[0][0].id
    return res.status(201).json({ id, message: `Usuário ${usuario} cadastrado com sucesso.` });
  } catch (err) {
    console.error('Erro na procedure insert_usuario:', err);

    // Erro customizado via SIGNAL SQLSTATE '45000'
    if (err.sqlState === '45000') {
      return res.status(400).json({ error: err.sqlMessage });
    }

    // Outros erros de banco (por exemplo, duplicata em UNIQUE)
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ error: err.sqlMessage });
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
    await db.execute(
      `CALL prc_usuario_update(?, ?, ?, ?, ?, ?)`,
      [id, nome, sobrenome, usuario, email, senha]
    );

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
    const [result] = await db.execute(
      'CALL prc_usuario_delete(?)',
      [id]
    );

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