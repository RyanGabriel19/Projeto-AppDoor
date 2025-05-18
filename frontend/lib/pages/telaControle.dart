import 'package:flutter/material.dart';
import 'package:frontend/pages/widgets_cadastro/custom_buttom.dart';

class telaControle extends StatefulWidget {
  @override
  _telaControleState createState() => _telaControleState();
}

class _telaControleState extends State<telaControle> {
  bool conectado = false;
  bool portaAberta = false;

  void conectarBluetooth() {
    setState(() {
      conectado = true;
    });
    print('bluetooth conectado');
  }

  void enviarComando(String comando) {
    if (!conectado) return;
    setState(() {
      portaAberta = comando == 'A';
    });
    print("comando enviaod $comando");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  onPressed: conectarBluetooth,
                  icon: Icon(Icons.bluetooth),
                  label: Text(conectado ? "Conectado" : "Conectar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: conectado ? Colors.blueGrey : Colors.blue,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    portaAberta ? Icons.lock_open : Icons.lock,
                    size: 150,
                    color: portaAberta ? Colors.green : Colors.red,
                  ),
                  SizedBox(height: 40),
                  CustomButton(
                    label: "ABRIR",
                    icon: Icons.lock_open,
                    startColor: Colors.lightGreen,
                    endColor: Colors.green,
                    onPressed: conectado ? () => enviarComando("A") : null,
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    label: "FECHAR",
                    icon: Icons.lock,
                    startColor: Colors.pinkAccent,
                    endColor: Colors.red,
                    onPressed: conectado ? () => enviarComando("F") : null,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
