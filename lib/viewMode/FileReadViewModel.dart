import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_push/data/common.dart';
import 'package:path/path.dart' as p;

class FileReadViewModel extends ChangeNotifier {
  List<FileSystemEntity> files = [];

  initView() {
    files.clear();
    initPathFiles(Common().sDCardDir);
//    initPathFiles(Common().sDCardDir).then((value) {
//      print("====我拿到了====${value.length}");
//      notifyListeners();
//    });
  }

  // 初始化该路径下的文件、文件夹
  initPathFiles(String path) async {
    List<FileSystemEntity> pathFiles = [];
    try {
      //目前我已经有了集合所有文件或者文件夹的集合
      Directory parentDir = await Directory(path);
      for (var v in parentDir.listSync()) {
        // 去除以 .开头的文件/文件夹
        if (p.basename(v.path).substring(0, 1) == '.') {
          continue;
        }
        if (FileSystemEntity.isFileSync(v.path)) {
          if (p.extension(v.path) == ".mp3") {
            files.add(v);
            files.sort(
                (a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
          }
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
      print("Directory does not exist！");
    }
  }
}
