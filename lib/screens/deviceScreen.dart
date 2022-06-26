import 'dart:async';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceScreen extends StatefulWidget {
  DeviceScreen({Key? key, required this.device, required this.rssi}) : super(key: key);
  final BluetoothDevice device;
  final rssi;

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  // flutterBlue
  String SERVICE_UUID = ''; // PUT HERE THE SERVICE UUID
  String CHARACTERISTIC_UUID = ''; // CHARACTERISTIC UUID GOES HERE

  late BluetoothCharacteristic targetCharacteristic;

  FlutterBlue flutterBlue = FlutterBlue.instance;

  String stateText = 'Connecting';

  String connectButtonText = 'Disconnect';

  String datetime = DateTime.now().toString().split('.')[0];

  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;

  StreamSubscription<BluetoothDeviceState>? _stateListener;

  @override
  initState() {
    super.initState();
    _stateListener = widget.device.state.listen((event) {
      debugPrint('event :  $event');
      if (deviceState == event) {
        return;
      }
      setBleConnectionState(event);
    });
    connect();
    discoverServices();
  }

  @override
  void dispose() {
    _stateListener?.cancel();
    disconnect();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  setBleConnectionState(BluetoothDeviceState event) {
    switch (event) {
      case BluetoothDeviceState.disconnected:
        stateText = 'Disconnected';
        connectButtonText = 'Connect';
        break;
      case BluetoothDeviceState.disconnecting:
        stateText = 'Disconnecting';
        break;
      case BluetoothDeviceState.connected:
        stateText = 'Connected';
        connectButtonText = 'Disconnect';
        break;
      case BluetoothDeviceState.connecting:
        stateText = 'Connecting';
        break;
    }
    deviceState = event;
    setState(() {});
  }

  Future<bool> connect() async {
    Future<bool>? returnValue;
    setState(() {
      stateText = 'Connecting';
    });

    await widget.device
        .connect(autoConnect: false)
        .timeout(Duration(milliseconds: 10000), onTimeout: () {
      returnValue = Future.value(false);
      debugPrint('timeout failed');

      setBleConnectionState(BluetoothDeviceState.disconnected);
    }).then((data) {
      if (returnValue == null) {
        debugPrint('connection successful');
        returnValue = Future.value(true);
      }
    });

    return returnValue ?? Future.value(false);
  }
  discoverServices() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      // do something with service
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;
            writeData(datetime);
            setState(() {
            });
          }
        });
      }
    });
  }
  writeData(String data){
    List<int> bytes = utf8.encode(data);
    targetCharacteristic.write(bytes);
  }

  Future<List<int>> readData() async {
    return await targetCharacteristic.read();
  }
  void disconnect() {
    try {
      setState(() {
        stateText = 'Disconnecting';
      });
      widget.device.disconnect();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu),
        centerTitle: true,
        title: const Text("Homepage"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              width: 36,
              height: 30,
              decoration: BoxDecoration(
                  color: Color(0xFFB28930),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(child: Text("0"),),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget> [
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFF8C2424),
                    image: DecorationImage(
                        image: AssetImage('assets/banner.jpeg'),
                        fit: BoxFit.cover
                    )
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                            Colors.black.withOpacity(.4),
                            Colors.black.withOpacity(.2),
                          ]
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("Device Info - ${widget.device.name.toUpperCase()}", style: TextStyle(color: Colors.white, fontSize: 15),),
                      SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Battery: 0%", style: TextStyle(color: Colors.white),), // QUERY BATERRY
                            SizedBox(width: 10.0,),
                            Text("Signal: ${widget.rssi}", style: TextStyle(color: Colors.white),)
                          ]
                      ),
                      SizedBox(height: 10.0,),
                      Text("MAC: ${widget.device.id.id}", style: TextStyle(color: Colors.white),),
                      SizedBox(height: 20.0,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0,),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(20),
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  children: <Widget>[
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF6067AC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Center(child: Text("Configuration", style: Theme.of(context).textTheme.bodyText1,)),
                      ),
                      onTap: (){
                        print("HELLO");
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF9A600F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text("Heart History", style: Theme.of(context).textTheme.bodyText1,)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF9A600F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text("Set Clock", style: Theme.of(context).textTheme.bodyText1,)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF6067AC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text("Set Sleep Time", style: Theme.of(context).textTheme.bodyText1,)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(widget.device.name),
  //     ),
  //     body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text('$stateText'),
  //             OutlinedButton(
  //                 onPressed: () {
  //                   if (deviceState == BluetoothDeviceState.connected) {
  //                     disconnect();
  //                   } else if (deviceState == BluetoothDeviceState.disconnected) {
  //                     connect();
  //                   } else {}
  //                 },
  //                 child: Text(connectButtonText)),
  //           ],
  //         )),
  //   );
  // }
}