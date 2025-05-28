import jwt from 'jsonwebtoken';

const SECRET_KEY = 'ryan123';
export function autenticarToken(req, res, next) {

const authHeader = req.headers['authorization'];
const token = authHeader && authHeader.split(' ')[1]

if(!token) return res.status(401).json(
    {
        erro:'token nao encontrado'
    }
);

jwt.verify(token, SECRET_KEY, (err, usuario)=>{
    if(err)
        return res.status(403).json({error: 'token invalido ou expiraod'})

    req.usuario = usuario;
    next();
});
}
