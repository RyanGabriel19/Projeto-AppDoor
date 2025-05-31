import jwt from 'jsonwebtoken';

const SECRET_KEY = 'ryan123';

export function autenticarToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ erro: 'Token não encontrado.' });
  }

  jwt.verify(token, SECRET_KEY, (err, usuario) => {
    if (err) {
      return res.status(403).json({ erro: 'Token inválido ou expirado.' });
    }

    req.usuario = usuario;
      console.log('Dados do token decodificado:', usuario);
    next();
  });
}
////