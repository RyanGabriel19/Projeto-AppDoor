import express from 'express';
import {
    getMovPorta,
    postMovPorta
 } from '../controllers/movPortaController.js';

const router = express.Router();

router.get('/movPorta/consultar', getMovPorta);
router.post('/movPorta/cadastrar', postMovPorta);

export default router;