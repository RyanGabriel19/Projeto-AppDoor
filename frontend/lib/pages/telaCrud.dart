import 'package:flutter/material.dart';
import '../services/ApiLog.dart';

class telaCrud extends StatefulWidget {
  const telaCrud({super.key});

  @override
  State<telaCrud> createState() => _TelaCrudState();
}

class _TelaCrudState extends State<telaCrud> {
  final LogService _logService = LogService();
  late Future<List<dynamic>> _logs;
  final TextEditingController _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _logs = _logService.fetchLogs(); // Busca todos os logs inicialmente
  }

  void _buscarLogs() {
    FocusScope.of(context).unfocus(); // Fecha o teclado
    String id = _idController.text.trim();
    if (id.isEmpty) {
      // Se vazio, busca todos os logs
      setState(() {
        _logs = _logService.fetchLogs();
      });
    } else if (int.tryParse(id) == null) {
      // Se não for número, avisa o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite um ID numérico válido.')),
      );
    } else {
      setState(() {
        _logs = _logService.fetchLogsPorID(id);
      });
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Logs da API', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      hintText: 'Digite o ID do usuário',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _buscarLogs(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _buscarLogs,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
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
                          color: Colors.blue[400],
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
                            color: Colors.white,
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
          ),
        ],
      ),
    );
  }
}
