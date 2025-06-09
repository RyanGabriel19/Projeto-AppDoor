import jwt from 'jsonwebtoken';





const SECRET_KEY = 'ryan123';

export function autenticarToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  console.log('Authorization header:', authHeader);

  if (!authHeader) {
    return res.status(401).json({ erro: 'Cabeçalho de autorização não encontrado.' });
  }

  const token = authHeader.split(' ')[1];
  console.log('Token extraído:', token);

  if (!token) {
    return res.status(401).json({ erro: 'Token não encontrado.' });
  }

  jwt.verify(token, SECRET_KEY, (err, decoded) => {
    if (err) {
      console.log('Erro na verificação do token:', err.message);
      return res.status(403).json({ erro: 'Token inválido ou expirado.' });
    }

    // Exibir o conteúdo decodificado para confirmar os dados
    console.log('Dados do token decodificado:', decoded);

    // Certifique-se de que 'id' está no token decodificado
    if (!decoded.id) {
      console.log('Token decodificado não contém o campo "id"');
      return res.status(403).json({ erro: 'Token inválido: id ausente.' });
    }

    req.usuario = decoded;
    next();
  });
}
