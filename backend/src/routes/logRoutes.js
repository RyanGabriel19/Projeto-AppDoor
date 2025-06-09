import express from 'express';
import { getLog, getLogID } from '../controllers/logController.js';

const router = express.Router();

router.get('/logs/consultar', getLog);
router.get('/logs/consultar/:id', getLogID);


export default router;