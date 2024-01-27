// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'package:biomedicalfinal/screen3.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class Bluetooth {
  static late BluetoothConnection? connection;
  static bool isConnected = false;
  static String deviceAddress = "00:21:13:03:BB:D9";
  static List<double> receivedDataList = [];
  static double area = 0;

  static Future<void> connectToDevice(String address) async {
    Bluetooth.connection = await BluetoothConnection.toAddress(address);
    String pass = '1234';
    pass = pass.trim();
    String receivedData = '';
    try {
      List<int> list = pass.codeUnits;
      Uint8List bytes = Uint8List.fromList(list);
      connection!.output.add(bytes);
      await connection!.output.allSent;
      isConnected = true;
      print('Connected to Arduino');

      connection!.input!.listen((Uint8List data) {
        // Concatenate the received data
        receivedData += String.fromCharCodes(data);

        // Check if the complete message is received
        if (receivedData.endsWith('\n')) {
          receivedData = receivedData.trim();

          try {
            print('Received Data: $receivedData');
            double parsedData = int.parse(receivedData.trim()) / 10;
            receivedDataList.add(parsedData);
            print("parsed hehe: $parsedData");
            print('Received Data packet: ${data.join(', ')}');
            print(receivedDataList);
            // Reset receivedData for the next message
            receivedData = '';
          } catch (e) {
            print('Error parsing data: $receivedData');
            // Handle the error as needed
          }

          // Reset receivedData for the next message
          receivedData = '';
        }
      }, onDone: () {
        isConnected = false;
      });
    } catch (exception, stackTrace) {
      print('Cannot connect, exception occurred: $exception');
      print('StackTrace: $stackTrace');
    }
  }

  void sendData(String data) async {
    data = data.trim();
    if (isConnected) {
      try {
        List<int> list = data.codeUnits;
        Uint8List bytes = Uint8List.fromList(list);
        connection!.output.add(bytes);
        await connection!.output.allSent;
        if (kDebugMode) {
          print('Data sent successfully');
        }
      } catch (e) {
        print('Error sending data: $e');
      }
    } else {
      print('BlConnection not yet initialized');
    }
  }

  static String startListening() {
    String receivedData = '';
    connection!.input!.listen(
      (Uint8List data) {
        receivedData = String.fromCharCodes(data);
        print('Received: $receivedData');
        // Handle your received data here
      },

      // Handle Bluetooth connection closed event
      onDone: () {
        print('Connection closed');
        connection = null;
      },
    );
    return receivedData;
  }

  static void stopBluetooth() {
    if (connection != null) {
      connection!.dispose();
      connection = null;
      print('Bluetooth Blconnection stopped');
    }
  }
}

// ========== WIDGET ========== //

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({Key? key}) : super(key: key);

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await requestStoragePermission();
    await requestLocationPermission();
    await requestBluetoothPermission();
    await requestBluetoothScanPermission();
    await requestConnectPermission();
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      // Permission granted, you can access storage
      print('Storage permission granted');
      return true;
    } else if (status == PermissionStatus.denied) {
      // Permission denied
      print('Storage permission denied');
      return false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      // Permission permanently denied
      print('Storage permission permanently denied. Open app settings.');
      await openAppSettings();
      return false;
    }

    // If status is restricted, unavailable, or limited, handle accordingly
    return false;
  }

  Future<void> requestLocationPermission() async {
    // Request location permission
    var status = await Permission.location.request();

    if (status.isGranted) {
      // Permission granted, you can proceed with location-related tasks
      print("Location permission granted");
    } else if (status.isDenied) {
      // Permission denied, handle accordingly
      print("Location permission denied");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> requestConnectPermission() async {
    // Request location permission
    var status = await Permission.bluetoothConnect.request();

    if (status.isGranted) {
      // Permission granted, you can proceed with location-related tasks
      print("Location permission granted");
    } else if (status.isDenied) {
      // Permission denied, handle accordingly
      print("Location permission denied");
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, navigate to app settings
      openAppSettings();
    }
  }

  Future<void> requestBluetoothPermission() async {
    var status = await Permission.bluetooth.request();

    if (status.isGranted) {
      // Permission granted, you can proceed with Bluetooth-related tasks
      print("Bluetooth permission granted");
    } else if (status.isDenied) {
      // Permission denied, handle accordingly
      print("Bluetooth permission denied");
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, navigate to app settings
      openAppSettings();
    }
  }

  Future<void> requestBluetoothScanPermission() async {
    var status = await Permission.bluetoothScan.request();

    if (status.isGranted) {
      // Permission granted, you can proceed with Bluetooth-related tasks
      print("Bluetooth permission granted");
    } else if (status.isDenied) {
      // Permission denied, handle accordingly
      print("Bluetooth permission denied");
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, navigate to app settings
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("Connect to Device"),
            onPressed: () async {
              print('Connect Button pressed');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return screenthree();
                  },
                ),
              );
              await Bluetooth.connectToDevice(Bluetooth.deviceAddress);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Bluetooth.connection!.close();
    super.dispose();
  }
}
