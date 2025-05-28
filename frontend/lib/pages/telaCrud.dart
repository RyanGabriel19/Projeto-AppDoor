import 'package:flutter/material.dart';
import '../services/ApiLog.dart';

class TelaCrud extends StatefulWidget {
  const TelaCrud({super.key});

  @override
  State<TelaCrud> createState() => _TelaCrudState();
}

class _TelaCrudState extends State<TelaCrud> {
  final LogService _logService = LogService();
  late Future<List<dynamic>> _logs;

  @override
  void initState() {
    super.initState();
    _logs = _logService.fetchLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Fundo azul clarinho
      appBar: AppBar(
        title: const Text('Logs da API'),
        backgroundColor: Colors.blue[700], // Azul escuro no appBar
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _logs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum log encontrado.',
                style: TextStyle(color: Colors.blueGrey, fontSize: 18),
              ),
            );
          } else {
            final logs = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[400], // Azul médio para a caixa
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    log.toString(),
                    style: const TextStyle(
                      color: Colors.white, // Texto branco
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Função que retorna o widget TelaCrud
Widget telaCrud() => const TelaCrud();
