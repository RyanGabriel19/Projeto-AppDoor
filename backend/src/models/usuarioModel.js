import { db } from "../config/db.js"

export async function selectUsuarios() {
    const [rows] = await db.query("SELECT * FROM USUARIO");
    return rows;
}

/////////////////////////////////////////////////////////////////////////////////////////////
//funcao que busca o usuario pelo email
export async function buscarUsuarios(email) {
    const [rows] = await db.query("SELECT senha, id, nome, usuario, email FROM USUARIO WHERE EMAIL = ?", [email]);
    return rows[0];
}

// export async function loginAdmin(email) {
//     const [senha_admin] = await db.query("SELECT senha FROM USUARIO WHERE EMAIL = 'admin@gmail.com'")
//     return senha_admin[0]
// }
////////////////////////////////////////////////////////////////////////////////////////////////
///

///funcao busca o usuario pelo id
export async function buscarUsuariosPorId(id){
    const[rows] = await db.query('SELECT * FROM USUARIO WHERE ID = ?', [id]);
    return rows[0];
     

}
/////////////////////////////////////////////////////////////////////////////////////////////


//funcao para inserir usuario
export async function insertUsuarios(nome, sobrenome, usuario, email, senha) {
    const [cadastrar] = await db.execute(
        "CALL prc_usuario_insert(?, ?, ?, ?, ?)", [nome, sobrenome, usuario, email, senha]
    );
    return cadastrar[0][0].id;
}

/////////////////////////////////////////////////////////////////////////////////////////////

//funcao para atualizar usuario
export async function updateUsuarios(id, nome, sobrenome, usuario, email, senha) {
    await db.execute(
        "CALL prc_usuario_update(?, ?, ?, ?, ?, ?)", [id, nome, sobrenome, usuario, email, senha]
        
    );
}

/////////////////////////////////////////////////////////////////////////////////////////////

//funcao para deletar usuario 
export async function deletarUsuarios(id) {
    const [result] = await db.execute( "CALL prc_usuario_delete(?)", [id]);
    return [result];
}