import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:crypto/crypto.dart';

import 'package:mop/mop.dart';
import 'package:fluwx/fluwx.dart';
import 'package:mop_demo/wx_pay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';


const WX_APP_ID = "微信APPID"; // 微信APPID
const WX_MCH_ID = "微信商户号"; // 微信商户号
const WX_UNIVERSAL_LINK = "universalLink"; // universalLink


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
                      Mop.instance.openApplet('5facb3a52dcbff00017469bd',
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
                      Mop.instance.openApplet('5fa214a29a6a7900019b5cc1');
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
                      Mop.instance.openApplet('5fa215459a6a7900019b5cc3');
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


// Platform messages are asynchronous, so we initialize in an async method.
Future<void> init() async {

  // 注册微信SDK
  registerWxApi(
      appId: WX_APP_ID, universalLink: WX_UNIVERSAL_LINK);

  weChatResponseEventHandler.listen((res) async {
    if (res is WeChatShareResponse) {
      print("weChatResponseEventHandler res:$res");
    } else if (res is WeChatPaymentResponse) {
      print("WeChat Pay errCode：" + res.errCode.toString());
      if (wxPayCompleter != null) {
        if (res.isSuccessful) {
          wxPayCompleter?.complete({"errCode": res.errCode});
        } else {
          wxPayCompleter?.complete(
              {"errMsg": "requestPayment:fail", "errCode": res.errCode});
        }
        wxPayCompleter = null;
      }
    } else if (res is WeChatLaunchMiniProgramResponse) {
      String msg = res.extMsg;
      print("WeChatLaunchMiniProgramResponse" + msg);
      var data = res.extMsg.toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("wechatLoginInfo", data);
      print("WeChatLaunchMiniProgramResponsedata" + data);
      
      if (Platform.isAndroid) {
        Map info = await Mop.instance.currentApplet();
        if (info["data"] != null) {
          info = info["data"];
        }
        print("info:$info , appId:${info["appId"]}");
        if (info["appId"] != null) {
          print("openApplet:${info["appId"]}");
          Mop.instance.openApplet(info["appId"]);
        }
      }
    }
  });

  final res = await Mop.instance.initialize(
        '22LyZEib0gLTQdU3MUauATBwgfnTCJjdr7FCnywmAEM=', 'bdfd76cae24d4313',
        apiServer: 'https://api.finclip.com', apiPrefix: '/api/v1/mop');
  print(res);
  
  // 注册微信登录接口
  Mop.instance.registerExtensionApi("login", wechatLogin);
  // 注册微信支付接口
  Mop.instance.registerExtensionApi("requestPayment", requestPayment);

}

Future<Map<String, dynamic>> wechatLogin(dynamic params) async {
  print("wechatLogin");
  /*
  1.没有关联微信时，返回成功
  2.errMsg要带有fail或ok
  3.有id，没path也认为没关联
  */
  String name = params["name"];
  Map appInfo = await Mop.instance.currentApplet();
  Map info = null;
  try {
    info = appInfo["data"]["wechatLoginInfo"];
  } catch (e) {
    return {"errMsg": "登录成功"};
  }

  if (info == null) {
    return {"errMsg": "登录成功"};
  }

  String path = info["profileUrl"] ?? "";
  String wechatOriginId = info["wechatOriginId"] ?? "";

  if (wechatOriginId.isEmpty) {
    return {"errMsg": "登录成功"};
  }

  if (path.isEmpty) {
    return {"errMsg": "登录成功"};
  }

  if (!(await isWeChatInstalled)) {
    return {"errMsg": "login:fail WeChat not installed"};
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("wechatLoginInfo");

  Fluttertoast.showToast(msg: "正在打开微信，请稍候...");
  launchWeChatMiniProgram(
    username: wechatOriginId,
    path: path,
    miniProgramType: WXMiniProgramType.RELEASE);

  Duration duration = Duration(milliseconds: 100);
  while (true) {
    await Future.delayed(duration);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString("wechatLoginInfo") ?? "";
    if (info.isNotEmpty) {
      // print("user1 user $info");
      Map<String, dynamic> user = jsonDecode(info);
      return user;
    }
  }
}

Completer wxPayCompleter;

Future<dynamic> requestPayment(dynamic params) async {
  if (!(await isWeChatInstalled)) {
    Fluttertoast.showToast(msg: "使用微信支付前，请先安装微信！");
    return {"errMsg": "requestPayment:fail WeChat not installed"};
  }

  try {
    WxPayOrderResp resp = await wxPayOrder();
    if (resp.code == 1) {
      wxPayCompleter = new Completer();
      wxPay(resp.prepay_id);
      return wxPayCompleter?.future;
    } else {
      return {"errMsg": "requestPayment:fail order failed"};
    }
  } on DioError catch (e) {
    Fluttertoast.showToast(msg: e.error, gravity: ToastGravity.CENTER);
    return {"errMsg": "requestPayment:fail " + e.error};
  } catch (e) {
    return {"errMsg": "requestPayment:fail " + e.toString()};
  }
}

void wxPay(String prepayId) {
  // a ~/ b 等效于 (a / b).toInt()
  int timeStamp = DateTime.now().millisecondsSinceEpoch ~/ 1000; // 秒
  Random random = new Random();
  String num = random.nextInt(1 << 32).toString();
  String nonceStr = md5.convert(utf8.encode(num)).toString();
  String sign = WX_APP_ID +
      "\n" +
      timeStamp.toString() +
      "\n" +
      nonceStr +
      "\n" +
      prepayId +
      "\n";
  sign = sha256.convert(utf8.encode(sign)).toString();
  sign = base64.encode(utf8.encode(sign));

  // 调起微信支付
  payWithWeChat(
    appId: WX_APP_ID,
    partnerId: WX_MCH_ID,
    prepayId: prepayId,
    // 微信订单详情扩展字符串，暂填写固定值Sign=WXPay
    packageValue: "Sign=WXPay",
    // 随机字符串，不长于32位
    nonceStr: nonceStr,
    timeStamp: timeStamp,
    sign: sign,
  );
}

Future<WxPayOrderResp> wxPayOrder() async {
  // 微信支付下单的后端接口
  var url = 'xxxxx';
  Dio dio = new Dio();
  Map data = {};

  Response response = await dio.post(url, data: data);
  final value = WxPayOrderResp.fromJson(response.data);
  return value;
}
