import 'package:flutter/material.dart';
import '/screens/bluetoothScan_scrn.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Arduino Bluetooth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Main screen set to BluetoothScreen
      home: const BluetoothScreen(),
    );
  }
}