import express from 'express';
import {
    getMovPorta,
    postMovPorta
 } from '../controllers/movPortaController.js';

const router = express.Router();

router.get('/movPorta', getMovPorta);
router.post('/movPorta', postMovPorta);

export default router;