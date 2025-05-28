import 'package:flutter/material.dart';
import 'package:frontend/services/ApiLogin.dart';

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
        nomeUsuario = perfil?['usuario'] ?? 'Nome não encontrado';
      });
    } catch (e) {
      setState(() {
        nomeUsuario = 'Erro ao carregar';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("$nomeUsuario", style: TextStyle(fontSize: 18)));
  }
}
