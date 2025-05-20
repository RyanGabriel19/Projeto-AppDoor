import { db } from "../config/db.js";

export async function selectLog() {
    const [rows] = await db.execute("SELECT * FROM LOG")
    return rows
}