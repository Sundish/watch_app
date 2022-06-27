
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'deviceScreen.dart';

class MyApp extends StatelessWidget {
  final title = 'Select Your Device';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
       debugShowCheckedModeBanner: false,
       theme: ThemeData(
         textTheme: const TextTheme(
           bodyText1: TextStyle(color: Color(0xFFD3D3D3)),
         )
       ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;

  @override
  initState() {
    super.initState();
    initBle();
  }

  void initBle() {
    // BLE
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }
  scan() async {
    if (await Permission.bluetoothScan.request().isGranted) {
      if (!_isScanning) {
        scanResultList.clear();
        flutterBlue.startScan(timeout: Duration(seconds: 5));
        flutterBlue.scanResults.listen((results) {
          scanResultList = results;
          setState(() {
          });
        });
      } else {
        flutterBlue.stopScan();
      }
    }
  }

  Widget deviceSignal(ScanResult r) {
    return Text(r.rssi.toString(), style: Theme.of(context).textTheme.bodyText1,);
  }

  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.id, style: Theme.of(context).textTheme.bodyText1,);
  }

  Widget deviceName(ScanResult r) {
    String name = '';

    if (r.device.name.isNotEmpty) {
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      name = r.advertisementData.localName;
    } else {
      name = 'N/A';
    }
    return Text(name, style: Theme.of(context).textTheme.bodyText1,);
  }

  Widget leading(ScanResult r) {
    return const CircleAvatar(
      backgroundColor: Color(0xFFB28930),
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
    );
  }

  void onTap(ScanResult r) {
    print('${r.device.name}');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeviceScreen(device: r.device, rssi: r.rssi)),
    );
  }

  Widget listItem(ScanResult r) {
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.separated(
          itemCount: scanResultList.length,
          itemBuilder: (context, index) {
            return listItem(scanResultList[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        backgroundColor: Color(0xFFB28930),
        child: Icon(_isScanning ? Icons.stop : Icons.search,),
      ),
    );
  }
}