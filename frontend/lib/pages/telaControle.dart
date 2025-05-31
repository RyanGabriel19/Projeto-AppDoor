import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:frontend/pages/bluetooth.dart';
import 'package:frontend/pages/widgets_cadastro/custom_buttom.dart';

class telaControle extends StatefulWidget {
  final BluetoothConnection? connection;

  const telaControle({Key? key, this.connection}) : super(key: key);

  @override
  _telaControleState createState() => _telaControleState();
}


class _telaControleState extends State<telaControle> {
  bool conectado = false;
  bool portaAberta = false;
  BluetoothConnection? _connection;

  @override
  void initState() {
    super.initState();
    _connection = widget.connection;
    conectado = _connection != null;
  }

  void enviarComando(String comando) {
    if (_connection == null || !_connection!.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Conexão Bluetooth não está ativa.")),
      );
      return;
    }

    try {
      _connection!.output.add(utf8.encode(comando));
      _connection!.output.allSent;
      setState(() {
        portaAberta = comando == 'A';
      });
      print("Comando enviado: $comando");
    } catch (e) {
      print("Erro ao enviar comando: $e");
    }
  }

  Future<void> conectarNovamente() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BluetoothConnectionPage()),
    );

    if (result is BluetoothConnection) {
      setState(() {
        _connection = result;
        conectado = true;
      });
    }
  }

  @override
  void dispose() {
    _connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle do Portão'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        portaAberta
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    portaAberta ? "Porta Aberta" : "Porta Fechada",
                    style: TextStyle(
                      color:
                          portaAberta
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: conectarNovamente,
                  icon: const Icon(Icons.bluetooth),
                  label: Text(conectado ? "Conectado" : "Conectar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: conectado ? Colors.blueGrey : Colors.red,
                  ),
                ),
              ],
            ),

            // Corpo
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    portaAberta ? Icons.lock_open : Icons.lock,
                    size: 150,
                    color: portaAberta ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    label: "ABRIR",
                    icon: Icons.lock_open,
                    startColor: Colors.lightGreen,
                    endColor: Colors.green,
                    onPressed: conectado ? () => enviarComando("A") : null,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    label: "FECHAR",
                    icon: Icons.lock,
                    startColor: Colors.pinkAccent,
                    endColor: Colors.red,
                    onPressed: conectado ? () => enviarComando("F") : null,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
