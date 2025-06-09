import 'package:flutter/material.dart';
import 'package:frontend/services/ApiLogin.dart';
import 'package:frontend/model/models_Usuarios.dart';
import 'package:frontend/services/funcoes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlterarSenhaPage extends StatefulWidget {
  const AlterarSenhaPage({Key? key}) : super(key: key);

  @override
  _AlterarSenhaPageState createState() => _AlterarSenhaPageState();
}

class _AlterarSenhaPageState extends State<AlterarSenhaPage> {
  final TextEditingController _senhaController = TextEditingController();
  bool _loading = false;
  String? _token;
  String? _usuarioId;

  @override
  void initState() {
    super.initState();
    carregarPerfil();
  }

  Future<void> carregarPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');

    if (token == null || token.isEmpty) {
      _showMessage('Usuário não autenticado. Faça login novamente.');
      return;
    }

    try {
      final Usuario? perfil = await Apilogin.getPerfilUsuario();
      if (perfil == null) {
        _showMessage('Erro ao carregar perfil.');
        return;
      }

      setState(() {
        _usuarioId = perfil.id.toString();
        _token = token;
      });
    } catch (e) {
      _showMessage('Erro ao carregar dados do usuário.');
    }
  }

  void _showMessage(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _alterarSenha() async {
    final novaSenha = _senhaController.text.trim();

    if (_usuarioId == null || _usuarioId!.isEmpty || _token == null) {
      _showMessage('Usuário não autenticado.');
      return;
    }

    if (novaSenha.isEmpty) {
      _showMessage('Por favor, preencha a nova senha.');
      return;
    }

    setState(() => _loading = true);

    try {
      String resposta = await Funcoes.alterarSenha(_usuarioId!, novaSenha, _token!);
      _showMessage(resposta);
      _senhaController.clear();
    } catch (e) {
      _showMessage('Erro ao alterar senha: ${e.toString()}');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Alterar Senha', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Digite sua nova senha',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _senhaController,
                decoration: InputDecoration(
                  labelText: 'Nova Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _alterarSenha,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Alterar Senha', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
