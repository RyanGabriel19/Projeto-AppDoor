import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
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

  List<BluetoothDevice> _devicesList = [];

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    bool permissionsGranted = await _requestPermissions();

    if (!permissionsGranted) {
      print("Permissões necessárias não concedidas.");
      // Aqui você pode mostrar um AlertDialog para o usuário.
      return;
    }

    // Ativar Bluetooth
    await FlutterBluetoothSerial.instance.requestEnable();

    // Listar dispositivos pareados
    _listDevices();
  }

  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [
          Permission.bluetooth,
          Permission.bluetoothConnect,
          Permission.bluetoothScan,
          Permission.locationWhenInUse,
        ].request();

    return statuses.values.every((status) => status.isGranted);
  }

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

      print('Conectado a ${device.name ?? "Desconhecido"}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Conectado a ${device.name ?? "Desconhecido"}')),
      );
    } catch (e) {
      print('Erro ao conectar: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao conectar: $e')));
    }

    setState(() {
      _isConnecting = false;
    });
  }

  void _sendCommand(String command) async {
    if (_connection != null && _connection!.isConnected) {
      _connection!.output.add(Uint8List.fromList(command.codeUnits));
      await _connection!.output.allSent;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Comando enviado: $command')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não conectado a nenhum dispositivo')),
      );
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
                    Text(
                      'Conectado a: ${_selectedDevice?.name ?? "Desconhecido"}',
                    ),
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
                    const Text('Selecione um dispositivo para conectar:'),
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
                          child: const Text('Conectar'),
                        ),
                      ),
                    ),
                    if (_isConnecting) const CircularProgressIndicator(),
                    if (_devicesList.isEmpty)
                      const Text('Nenhum dispositivo pareado encontrado.'),
                  ],
                ),
      ),
    );
  }
}
