import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';

class Bluetooth extends StatefulWidget {
  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  BluetoothDevice? _selectedDevice;
  BluetoothConnection? _connection;
  bool _isConnecting = false;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _listDevices();
  }

  List<BluetoothDevice> _devicesList = [];

  void _listDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    } catch (e) {
      print("Erro ao listar dispositivos: $e");
    }

    setState(() {
      _devicesList = devices;
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _isConnecting = true;
    });

    try {
      BluetoothConnection connection = await BluetoothConnection.toAddress(
        device.address,
      );
      setState(() {
        _connection = connection;
        _connected = true;
        _selectedDevice = device;
      });

      print('Conectado a ${device.name}');
    } catch (e) {
      print('Erro ao conectar: $e');
    }

    setState(() {
      _isConnecting = false;
    });
  }

  void _sendCommand(String command) {
    if (_connection != null && _connection!.isConnected) {
      _connection!.output.add(Uint8List.fromList(command.codeUnits));
      _connection!.output.allSent;
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
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _connected
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Conectado a: ${_selectedDevice!.name}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _sendCommand("1"), // Abrir portão
                      child: const Text("Abrir Portão"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _sendCommand("0"), // Fechar portão
                      child: const Text("Fechar Portão"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                )
                : Column(
                  children: [
                    Text('Selecione um dispositivo para conectar:'),
                    const SizedBox(height: 10),
                    ..._devicesList.map(
                      (device) => ListTile(
                        title: Text(device.name ?? "Desconhecido"),
                        subtitle: Text(device.address),
                        trailing: ElevatedButton(
                          onPressed:
                              _isConnecting
                                  ? null
                                  : () => _connectToDevice(device),
                          child: Text('Conectar'),
                        ),
                      ),
                    ),
                    if (_isConnecting) CircularProgressIndicator(),
                  ],
                ),
      ),
    );
  }
}
