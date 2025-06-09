import 'package:flutter/material.dart';
import 'package:frontend/services/ApiLogin.dart';
import 'package:frontend/model/models_Usuarios.dart';
import 'package:frontend/services/funcoes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class telaConfig extends StatefulWidget {
  @override
  _telaConfigState createState() => _telaConfigState();
}

class _telaConfigState extends State<telaConfig> {
  String nomeUsuario = 'Carregando...';

  @override
  void initState() {
    super.initState();
    carregarPerfil();
  }

  Future<void> carregarPerfil() async {
    try {
      final perfil = await Apilogin.getPerfilUsuario();
      setState(() {
        nomeUsuario = perfil?.nome ?? 'Nome não encontrado';
      });
    } catch (e) {
      setState(() {
        nomeUsuario = 'Erro ao carregar';
      });
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpa todos os dados salvos

    // Navega para a tela de login e remove todas as anteriores
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void mudarNomeUsuario() {
    Navigator.of(context).pushNamed('/mudarsenha');
  }

  void excluirConta() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirmar exclusão'),
            content: Text('Tem certeza que deseja excluir sua conta?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Excluir', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmar == true) {
      final perfil = await Apilogin.getPerfilUsuario();
      if (perfil != null) {
        try {
          String mensagem = await Funcoes.deletUsuario(perfil.id.toString());
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(mensagem)));
          return logout();
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text(
          'Tela de Configurações',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Topo com o nome do usuário
            Text(
              'Bem-vindo,',
              style: TextStyle(fontSize: 22, color: Colors.grey[700]),
            ),
            SizedBox(height: 4),
            Text(
              nomeUsuario,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),

            // Espaço entre o nome e os botões
            Spacer(),

            // Botões
            _buildBotao(
              icon: Icons.logout,
              label: 'Sair',
              onTap: logout,
              corTexto: Colors.white,
              corBorda: Colors.blue[800]!,
            ),
            SizedBox(height: 20),
            _buildBotao(
              icon: Icons.edit,
              label: 'Mudar Senha',
              onTap: mudarNomeUsuario,
              corTexto: Colors.white,
              corBorda: Colors.blue[800]!,
            ),
            SizedBox(height: 20),
            _buildBotao(
              icon: Icons.delete_forever,
              label: 'Excluir conta',
              onTap: excluirConta,
              corTexto: Colors.red,
              corBorda: Colors.blue[800]!,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildBotao({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color corTexto,
    required Color corBorda,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: corTexto),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(label, style: TextStyle(color: corTexto, fontSize: 16)),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: corBorda, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.blue[800]!,
        ),
      ),
    );
  }
}
