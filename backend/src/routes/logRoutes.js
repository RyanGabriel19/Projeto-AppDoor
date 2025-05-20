import express from 'express';
import { getLog } from '../controllers/logController.js';

const router = express.Router();

router.get('/log/consultar', getLog);

export default router;