import { db } from "../config/db.js"

export async function selectUsuarios() {
    const [rows] = await db.query("SELECT * FROM USUARIO");
    return rows;
}

/////////////////////////////////////////////////////////////////////////////////////////////

export async function buscarUsuarios(email) {
    const [rows] = await db.query("SELECT senha FROM USUARIO WHERE EMAIL = ?", [email]);
    return rows[0];
}

/////////////////////////////////////////////////////////////////////////////////////////////

export async function insertUsuarios(nome, sobrenome, usuario, email, senha) {
    const [cadastrar] = await db.execute(
        "CALL prc_usuario_insert(?, ?, ?, ?, ?)", [nome, sobrenome, usuario, email, senha]
    );
    return cadastrar[0][0].id;
}

/////////////////////////////////////////////////////////////////////////////////////////////

export async function updateUsuarios(id, nome, sobrenome, usuario, email, senha) {
    await db.execute(
        "CALL prc_usuario_update(?, ?, ?, ?, ?, ?)", [id, nome, sobrenome, usuario, email, senha]
    );
}

/////////////////////////////////////////////////////////////////////////////////////////////

export async function deletarUsuarios(id) {
    await db.execute(
        "CALL prc_usuario_delete(?)", [id]
    );
}