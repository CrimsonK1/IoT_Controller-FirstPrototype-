import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class StatusScreen extends StatelessWidget {
  // Received data from the active connection
  final BluetoothConnection connection;
  final BluetoothDevice device;

  // The constructor requires the connection and device information
  const StatusScreen({
    Key? key,
    required this.connection,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de la Conexión'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              margin: const EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Detalles del Dispositivo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Display device name and address
                    Text('Nombre: ${device.name ?? "Desconocido"}'),
                    Text('Dirección: ${device.address}'),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    const Text(
                      'Estado de la Conexión',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Verrify and show connection status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          connection.isConnected ? Icons.check_circle : Icons.error,
                          color: connection.isConnected ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          connection.isConnected ? 'CONECTADO' : 'DESCONECTADO',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: connection.isConnected ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}