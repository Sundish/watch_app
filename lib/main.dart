import 'package:flutter/material.dart';
import 'package:watch_app/screens/configscreen.dart';
import 'package:watch_app/helpers/blue_helper.dart';
import 'package:watch_app/screens/selectScreen.dart';

void main() => runApp(MyApp()
  // MaterialApp(
  //  debugShowCheckedModeBanner: false,
  //  theme: ThemeData(
  //    textTheme: const TextTheme(
  //      bodyText1: TextStyle(color: Color(0xFFD3D3D3)),
  //    )
  //  ),
  //  home: HomePage(),
  //)
);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                      Text("Device Info - OGOPOGO", style: TextStyle(color: Colors.white, fontSize: 15),),
                      SizedBox(height: 10.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Battery: 0%", style: TextStyle(color: Colors.white),),
                            SizedBox(width: 10.0,),
                            Text("Signal: 0%", style: TextStyle(color: Colors.white),)
                          ]
                      ),
                      SizedBox(height: 10.0,),
                      Text("MAC: A56B 8128 2183 1838", style: TextStyle(color: Colors.white),),
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
}
