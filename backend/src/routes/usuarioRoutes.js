import express from 'express';
import { 
    getUsuarios,
    postUsuariosLogin,
    postUsuarios,
    putUsuarios,
    deleteUsuarios
 } from '../controllers/usuarioController.js';

const router = express.Router();

router.get('/usuarios/consultar', getUsuarios);
router.post('/usuarios/entrar', postUsuariosLogin);
router.post('/usuarios/cadastrar', postUsuarios);
router.put('/usuarios/atualizar/:id', putUsuarios);
router.delete('/usuarios/deletar/:id', deleteUsuarios);

export default router;
