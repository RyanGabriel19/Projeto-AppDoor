import express from 'express';
import { 
    getUsuarios,
    postUsuarios,
    putUsuarios,
    deleteUsuarios
 } from '../controllers/usuarioController.js';

const router = express.Router();

router.get('/usuarios', getUsuarios);
router.post('/usuarios', postUsuarios);
router.put('/usuarios/:id', putUsuarios);
router.delete('/usuarios/:id', deleteUsuarios);

export default router;
