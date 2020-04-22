import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:mop/mop.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> init() async {
    if (Platform.isIOS) {
      final res = await Mop.instance.initialize(
          '22LyZEib0gLTQdU3MUauAZ0pZVbKTWGmNN6Lx8hXhIkA', '74bde5fad53a817c',
          apiServer: 'https://mp.finogeeks.com', apiPrefix: '/api/v1/mop');
      print(res);
    } else if (Platform.isAndroid) {
      final res = await Mop.instance.initialize(
          '22LyZEib0gLTQdU3MUauAZ0pZVbKTWGmNN6Lx8hXhIkA', '74bde5fad53a817c',
          apiServer: 'https://mp.finogeeks.com', apiPrefix: '/api/v1/mop');
      print(res);
    }
    if (!mounted) return;
  }

  // 5e637a18cbfae4000170fa7a
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('凡泰极客小程序 Flutter 插件'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                      colors: const [Color(0xFF12767e), Color(0xFF0dabb8)],
                      stops: const [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: FlatButton(
                    onPressed: () {
                      Mop.instance.openApplet('5ea03fa563cb900001d73863',
                          path: 'pages/index/index', query: '');
                    },
                    child: Text(
                      '打开画图小程序',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                      colors: const [Color(0xFF12767e), Color(0xFF0dabb8)],
                      stops: const [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: FlatButton(
                    onPressed: () {
                      Mop.instance.openApplet('5ea0401463cb900001d73865');
                    },
                    child: Text(
                      '打开官方小程序',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                      colors: const [Color(0xFF12767e), Color(0xFF0dabb8)],
                      stops: const [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: FlatButton(
                    onPressed: () {
                      Mop.instance.openApplet('5ea0412663cb900001d73867');
                    },
                    child: Text(
                      '我的对账单',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
