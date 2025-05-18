import { db } from "../config/db.js";

export async function getLog (req, res, next) {
    try {
        const [rows] = await db.query('SELECT * FROM LOG');
        res.status(200).json(rows);
    } catch (err) {
        console.error('Erro ao buscar os logs:', err)
        res.status(500).json({error: 'Erro ao buscar logs.'})
    }
}