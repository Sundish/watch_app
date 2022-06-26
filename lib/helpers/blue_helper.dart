import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:flutter_blue/flutter_blue.dart';

class BlueScreen extends StatefulWidget {
  const BlueScreen({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  State<BlueScreen> createState() => _BlueScreenState();
}

class _BlueScreenState extends State<BlueScreen> {
  final String SERVICE_UUID = "";
  final String CHARACTERISTIC_UUID = "";
  late bool isReady;
  late Stream<List<int>> stream;
  late BluetoothCharacteristic characteristic;

  @override
  void initState(){
    super.initState();
    connectToDevice();
  }

  connectToDevice() async {
    // ignore: unnecessary_null_comparison
    if(widget.device == null){
      _Pop();
      return;
    }
    Timer(const Duration(seconds: 15), () {
      if(!isReady){
        disconnectFromDevice();
        _Pop();
      }
    });
    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice(){
    if(widget.device == null){
      _Pop();
      return;
    }
    widget.device.disconnect();
  }

  discoverServices() async {
    if(widget.device == null) {
      _Pop();
      return;
    }
    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if(service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if(characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;
            setState((){
              isReady = true;
            });
          }
        });
      }
    });

    if(!isReady){
      _Pop();
    }
  }

  _onWillPop() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to disconnect device and go back?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('No')),
            TextButton(onPressed: () {
              disconnectFromDevice();
              Navigator.of(context).pop(false);
              }, child: const Text('Yes')),

          ],
        );
      }
    );
  }

  _Pop(){
   Navigator.of(context).pop(true);
  }
  writeDataAndWaitForRespond() async {
    writeData("A 300 300 300");
    List<BluetoothService> services = await widget.device.discoverServices();
    print("////////////////We're here, listening to Hive...");
    // isDeviceTurnedOn = true;
    services.forEach((service) async {
      Future.delayed(const Duration(milliseconds: 500), () async {
        print("Entered the loop...");
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          List<int> value = await c.read();
          String stringValue = new String.fromCharCodes(value);
          print("The recieved Characteristic Value is $stringValue and $value");
          print("Entered the second loop...");
          var descriptors = c.descriptors;
          print("The descriptors value is equal to: $descriptors");
          for (BluetoothDescriptor d in descriptors) {
            List<int> value = await d.read();
            print("Entered the third loop...");
            String stringValue = new String.fromCharCodes(value);
            print("The recieved Value is $stringValue and $value");
          }
        }
      });
    });
  }
  writeData(String data) {
    if (characteristic == null) return;

    List<int> bytes = utf8.encode(data);
    characteristic.write(bytes);
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
