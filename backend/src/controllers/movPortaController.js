import { db } from "../config/db.js";

//////////////////////////////////////////////////////////////////////////////////////

export async function getMovPorta (req, res, next) {
    try {
        const [rows] = await db.query('SELECT * FROM MOV_PORTA');
        res.status(200).json(rows);
    } catch (err) {
        console.error('Erro ao buscar as movimentações da porta:', err)
        res.status(500).json({ error: 'Erro ao buscar as movimentações da porta.' })
    }
}

//////////////////////////////////////////////////////////////////////////////////////

export async function postMovPorta(req, res, next) {
    const { id_usuario_mov, tipo_mov, status_porta } = req.body;
    try {
        const [inserir] = await db.execute(
            `CALL prc_mov_porta_insert(?, ?, ?)`, [id_usuario_mov, tipo_mov, status_porta]
        );
        return res.status(201).json({id_usuario: id_usuario_mov, message: tipo_mov})
    } catch (err) {
        console.error('Erro na procedure de insert mov_porta:', err)

        // Erro customizado via SIGNAL SQLSTATE '45000'
        if (err.sqlState === '45000') {
        return res.status(400).json({ error: err.sqlMessage });
        }
    }
}