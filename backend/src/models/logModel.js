import { db } from "../config/db.js";


export async function selectLog(){
   const [rows] = await db.execute("SELECT * FROM LOG");
    return rows;
}
  
   
export async function selectLogID(id) {
  const [rows] = await db.execute("SELECT * FROM LOG WHERE ID_USUARIO = ?", [id]);
  return rows;
}
