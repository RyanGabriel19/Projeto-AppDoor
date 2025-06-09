import { selectLog, selectLogID } from "../models/logModel.js";


export async function getLog(req, res) {
  try {

    const rows = await selectLog(); 
    res.status(200).json(rows);
  } catch (err) {
    console.error('Erro ao buscar os logs:', err);
    res.status(500).json({ error: 'Erro ao buscar logs.' });
  }
}


export async function getLogID(req, res) {
  try {
    const { id } = req.params; // pega o ID 
    const rows = await selectLogID(id); // passa o ID para o model
    res.status(200).json(rows);
  } catch (err) {
    console.error('Erro ao buscar os logs:', err);
    res.status(500).json({ error: 'Erro ao buscar logs.' });
  }
}
