import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('com.accubits.flutter/wallet_connect_info');

  String walletHash = "";

  Future<void> _connectToWallet() async {
    try {
      await platform.invokeMethod('connectToWallet');
    } catch (e){
      log('Something went wrong.'+ e.toString());
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _getAccounts() async {
    try {
      final List<Object?> result = await platform.invokeMethod('getAccounts');
      setState(() {
        walletHash = result.first.toString();
      });
      print(walletHash);
    } catch(e){

      log('No account Found. Try connecting the wallet application first.'+ e.toString());
    }
  }

  Future<void> _sendTransaction() async {
    try {
      final List<Object?> result = await platform.invokeMethod(
          'sendTransaction');
      setState(() {
        walletHash = result.first.toString();
      });
      print(walletHash);
    } catch(e){
      log('Error Sending Transaction.'+ e.toString());
    }
  }


  @override
  void didChangeDependencies()  async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _getAccounts();
              },
              child: Text('Get Account Address'),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                _sendTransaction();
              },
              child: Text('Send Transaction'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _connectToWallet();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
