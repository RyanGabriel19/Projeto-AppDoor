import express from 'express';
import cors from 'cors';
import usuarioRoutes from './routes/usuarioRoutes.js';
import logRoutes from './routes/logRoutes.js'
import movPortaRoutes from './routes/movPortaRoutes.js'

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors())
app.use(express.json());
app.use(usuarioRoutes, logRoutes, movPortaRoutes);

// '/api', 
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
