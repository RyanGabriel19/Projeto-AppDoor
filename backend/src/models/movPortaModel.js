import { db } from "../config/db.js"

export async function selectMovPorta() {
    const [rows] = await db.query("SELECT * FROM MOV_PORTA")
    return rows;
}

export async function insertMovPorta(id_usuario_mov, status_porta) {
    await db.execute(
        "CALL prc_mov_porta_insert(?, ?)", [id_usuario_mov, status_porta]
    );
}