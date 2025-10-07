import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'Status_scrn.dart'; 

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({Key? key}) : super(key: key);

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  // Instance for Bluetooth plugin
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  // Variables to manage connection state
  BluetoothConnection? _connection;
  bool get isConnected => _connection?.isConnected ?? false;

  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _isDiscovering = false;

  @override
  void initState() {
    super.initState();
    _startDiscovery(); // Start discovering devices when the screen is initialized
  }
  
  @override
  void dispose() {
    if (isConnected) {
      _connection?.dispose();
      _connection = null;
    }
    super.dispose();
  }
  // Method to start discovering devices
  void _startDiscovery() {
    setState(() {
      _isDiscovering = true;
      _devicesList = [];
    });

    _bluetooth.startDiscovery().listen((r) {
      setState(() {
        final existingIndex = _devicesList.indexWhere(
            (device) => device.address == r.device.address);
        if (existingIndex >= 0) {
          _devicesList[existingIndex] = r.device;
        } else {
          // Only add devices with a name
          if(r.device.name != null){
             _devicesList.add(r.device);
          }
        }
      });
    }).onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }
  // Method to connect to a selected device
  void _connect(BluetoothDevice device) async {
    if (isConnected) {
      await _connection?.close();
    }
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      setState(() {
        _device = device;
      });
      // Listen for incoming data
      _connection!.input!.listen((Uint8List data) {
        print('Data incoming: ${String.fromCharCodes(data)}');
      });

    } catch (exception) {
      print('Cannot connect, exception occured');
    }
  }

  // Method to disconnect from the device
  void _disconnect() {
    _connection?.close();
    setState(() {
      _device = null; // Clear the selected device on disconnection
    });
  }
  
  void _sendMessage(String text) async {
    if (isConnected) {
      _connection!.output.add(Uint8List.fromList(text.codeUnits));
      await _connection!.output.allSent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conexión Bluetooth'),
        actions: [
          // Button to navigate to StatusScreen
          if (isConnected)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                // Logic to navigate to StatusScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatusScreen(
                      connection: _connection!,
                      device: _device!,
                    ),
                  ),
                );
              },
            ),
          IconButton(
            icon: Icon(
              _isDiscovering ? Icons.stop : Icons.search,
            ),
            onPressed: _startDiscovery,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          _buildConnectionStatus(),
          Expanded( // List of discovered devices
            child: ListView.builder(
              itemCount: _devicesList.length,
              itemBuilder: (context, index) {
                BluetoothDevice device = _devicesList[index];
                return ListTile(
                  title: Text(device.name ?? 'Dispositivo Desconocido'),
                  subtitle: Text(device.address),
                  trailing: ElevatedButton(
                    child: const Text('Conectar'),
                    onPressed: () => _connect(device),
                  ),
                );
              },
            ),
          ),
          if(isConnected) _buildDataSender() // Data sender buttons
        ],
      ),
    );
  }
  // Widget to show connection status
  Widget _buildConnectionStatus() {
    String statusText;
    Color statusColor;

    if (isConnected) {
      statusText = 'Conectado a ${_device?.name ?? _device?.address}';
      statusColor = Colors.green;
    } else if (_isDiscovering) {
      statusText = 'Buscando dispositivos...';
      statusColor = Colors.orange;
    } else {
      statusText = 'Desconectado';
      statusColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      color: statusColor,
      width: double.infinity,
      child: Text(
        statusText,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Disconnect button and data sender buttons
  Widget _buildDataSender() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               ElevatedButton(
                child: const Text('Enviar ON'),
                onPressed: () => _sendMessage("ON"), //Send "ON" command
              ),
              ElevatedButton(
                child: const Text('Enviar OFF'),
                onPressed: () => _sendMessage("OFF"), //Send "OFF" command
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Disconnect button
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: _disconnect,
            child: const Text('Desconectar', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}