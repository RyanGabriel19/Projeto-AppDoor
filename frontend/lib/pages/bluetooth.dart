import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:frontend/pages/telaControle.dart';
import 'package:frontend/services/ApiLogin.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothConnectionPage extends StatefulWidget {
  @override
  _BluetoothConnectionPageState createState() => _BluetoothConnectionPageState();
}

class _BluetoothConnectionPageState extends State<BluetoothConnectionPage> {
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
      return;
    }

    await FlutterBluetoothSerial.instance.requestEnable();
    _listDevices();
  }

  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.locationWhenInUse,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  String emailUsuario = '';
  Future<void> carregarPerfil() async {
    try {
      final perfil = await Apilogin.getPerfilUsuario();
      setState(() {
        emailUsuario = perfil?['email'] ?? 'email não encontrado';
      });
    } catch (e) {
      setState(() {
        emailUsuario = 'Erro ao carregar';
      });
    }
  }

  void _listDevices() async {
    try {
      final devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      setState(() {
        _devicesList = devices;
      });
    } catch (e) {
      print("Erro ao listar dispositivos: $e");
    }
  }

  void _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _isConnecting = true;
    });

    try {
      BluetoothConnection connection = await BluetoothConnection.toAddress(device.address);
      setState(() {
        _connection = connection;
        _connected = true;
        _selectedDevice = device;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => telaControle(connection: _connection),
        ),
      );

      print('Conectado a ${device.name ?? "Desconhecido"}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Conectado a ${device.name ?? "Desconhecido"}')),
      );
    } catch (e) {
      print('Erro ao conectar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar: $e')),
      );
    }

    setState(() {
      _isConnecting = false;
    });
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
        child: _connected
            ? Center(
                child: Text('Conectado a: ${_selectedDevice?.name ?? "Desconhecido"}'),
              )
            : Column(
                children: [
                  const Text('Selecione um dispositivo para conectar:'),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: _devicesList
                          .map(
                            (device) => ListTile(
                              title: Text(device.name ?? "Desconhecido"),
                              subtitle: Text(device.address),
                              trailing: ElevatedButton(
                                onPressed: _isConnecting ? null : () => _connectToDevice(device),
                                child: const Text('Conectar'),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  // Botão para navegar para a tela de controle, somente se conectado
                  ElevatedButton(
                    onPressed: (_connection != null && _connected)
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => telaControle(connection: _connection),
                              ),
                            );
                          }
                        : null,
                    child: const Text('Ir para Home'),
                  ),

                  if (_isConnecting) const CircularProgressIndicator(),
                  if (_devicesList.isEmpty) const Text('Nenhum dispositivo pareado encontrado.'),
                ],
              ),
      ),
    );
  }
}
