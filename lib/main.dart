import 'package:flutter/material.dart';

import 'dart:async';

import 'package:jpush_flutter/jpush_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String debugLable = 'Unknown';
  final JPush jPush = new JPush();

  @override
  void initState() {
    super.initState();
    // 配置jpush(不要省略）
    jPush.setup(
        appKey: "b871d045492eb2901c80dfef",
        channel: '9b3ee30496789dbda89444f3');
    initPlatformState().then((value) {});
    // 监听jpush
//    jPush.addEventHandler(
//      onReceiveNotification: (Map<String, dynamic> message) async {
//        print("flutter 接收到推送: $message");
//      },
//      onOpenNotification: (Map<String, dynamic> message) {
//        // 点击通知栏消息，在此时通常可以做一些页面跳转等
//      },
//    );
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      jPush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>flutter 接受到推送信息${message}');
          debugLable = '接收到推送：${message}';
        },
        onOpenNotification: (Map<String, dynamic> message) {
       // 点击通知栏消息，在此时通常可以做一些页面跳转等
        },
      );
    } on Exception {
      platformVersion = '平台版本获取失败，请检查!';
    }
    if (!mounted) return;
    setState(() {
      debugLable = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('极光推送'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Text('结果:${debugLable}'),
                FlatButton(
                  child: Text('发送推送信息'),
                  onPressed: () {
                    var fireDate = DateTime.fromMillisecondsSinceEpoch(
                        DateTime.now().millisecondsSinceEpoch);
                    var localNotification = LocalNotification(
                      id: 234,
                      title: '测试本地推送',
                      buildId: 1,
                      content: '我是本地推送的消息',
                      fireTime: fireDate,
                      subtitle: 'ios 消息推送',
                      // 该参数只有在 iOS 有效
                      badge: 5, // 该参数只有在 iOS 有效
//                      extra: {"fa": "0"} // 设置 extras ，extras 需要是 Map<String, String>
                    );
                    jPush.sendLocalNotification(localNotification).then((res) {
                      setState(() {
                        debugLable = res;
                      });
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
