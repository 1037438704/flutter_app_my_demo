import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_push/pages/FileReadPage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'data/common.dart';
import 'data/modify_path_provider.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  Future<void> getSDCardDir() async {
    Common().sDCardDir = (await getExternalStorageDirectory()).path;
  }

//   Permission check
  Future<void> getPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      }
      await getSDCardDir();
    } else if (Platform.isIOS) {
      await getSDCardDir();
    }
  }
  Future.wait([initializeDateFormatting("zh_CN", null), getPermission()]).then((
      result) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter File Manager",
      theme: ThemeData(
//          platform: TargetPlatform.iOS,
          primarySwatch: Colors.red
      ),
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("选择"),),
      body: Column(
        children: <Widget>[
          MaterialButton(
            child: Text("mp3"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FileReadPage()));
            },
          )
        ],
      ),
    );
  }

}




