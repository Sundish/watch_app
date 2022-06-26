import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  bool _switchValue = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu),
        centerTitle: true,
        title: const Text("Configuration"),
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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ScreenNumber", style: Theme.of(context).textTheme.bodyText1,),
                      SizedBox(width: 100.0,),
                      CupertinoSwitch(value: _switchValue, onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                      })
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
