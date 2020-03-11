import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_push/pages/file_manager.dart';
import 'package:flutter_app_push/pages/my_app_state.dart';
import 'package:flutter_app_push/pages/this_file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/common.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future<void> getSDCardDir() async {
    Common().sDCardDir = (await getExternalStorageDirectory()).path;
  }

  // Permission check
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
      title: 'Flutter File Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("选择进入方式"),),
      body: Column(
        children: <Widget>[
          MaterialButton(
            child: Text("极光推送"),
            minWidth: double.maxFinite,
            color: Colors.red,
            onPressed: () =>
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyJiGuangPage())),
          ),
          MaterialButton(
            child: Text("类似于文件管理"),
            minWidth: double.maxFinite,
            color: Colors.red,
            onPressed: () =>
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FileManager())),
          ),
          MaterialButton(
            child: Text("筛选根目录的所有文件"),
            minWidth: double.maxFinite,
            color: Colors.red,
            onPressed: () =>
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyFileManager(0))),
          ),
          MaterialButton(
            child: Text("筛选所有文件"),
            minWidth: double.maxFinite,
            color: Colors.red,
            onPressed: () =>
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyFileManager(1))),
          ),
        ],
      ),
    );
  }


}
