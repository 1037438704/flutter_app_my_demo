import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_push/data/common.dart';
import 'package:flutter_app_push/private/provider_widget.dart';
import 'package:flutter_app_push/viewMode/FileReadViewModel.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

/*
 *   作者：NinetailFox
 *   时间：2020/3/7 21:15
 *   邮箱：1037438704@qq.com 
 *   说明：文件读取
 */
class FileReadPage extends StatefulWidget {
  @override
  _FileReadPageState createState() => _FileReadPageState();
}

class _FileReadPageState extends State<FileReadPage> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'SD Card',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.red,
          elevation: 0.0,
        ),
        body: ProviderWidget<FileReadViewModel>(
          model: FileReadViewModel(),
          onModelReady: (value) => value.initView(),
          builder: (context, viewModel, child) {
            return viewModel.files.length == 0
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Scrollbar(
                    child: ListView.builder(
                      controller: controller,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: viewModel.files.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (FileSystemEntity.isFileSync(
                            viewModel.files[index]?.path)) {
                          return _buildFileItem(viewModel.files[index]);
                        } else {
                          return _buildFolderItem(viewModel.files[index]);
                        }
                      },
                    ),
                  );
          },
        ));
  }

  Widget _buildFileItem(FileSystemEntity file) {
    String modifiedTime = DateFormat('yyyy-MM-dd HH:mm:ss', 'zh_CN')
        .format(file.statSync().modified.toLocal());
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Color(0xffe5e5e5))),
        ),
        child: ListTile(
          leading: Image.asset(Common().selectIcon(p.extension(file.path))),
          title: Text(file.path.substring(file.parent.path.length + 1)),
          subtitle: Text(
              '$modifiedTime  ${Common().getFileSize(file.statSync().size)}',
              style: TextStyle(fontSize: 12.0)),
        ),
      ),
      onTap: () {
//        OpenFile.open(file.path);
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoButton(
                  pressedOpacity: 0.6,
                  child:
                      Text('重命名', style: TextStyle(color: Color(0xff333333))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoButton(
                  pressedOpacity: 0.6,
                  child: Text('删除', style: TextStyle(color: Color(0xff333333))),
                  onPressed: () {
                    Navigator.pop(context);
//                    deleteFile(file);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFolderItem(FileSystemEntity file) {
    String modifiedTime = DateFormat('yyyy-MM-dd HH:mm:ss', 'zh_CN')
        .format(file.statSync().modified.toLocal());

    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Color(0xffe5e5e5))),
        ),
        child: ListTile(
          leading: Image.asset('assets/images/folder.png'),
          title: Row(
            children: <Widget>[
              Expanded(
                  child:
                      Text(file.path.substring(file.parent.path.length + 1))),
              Text(
                '${_calculateFilesCountByFolder(file)}项',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          subtitle: Text(modifiedTime, style: TextStyle(fontSize: 12.0)),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      onTap: () {},
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoButton(
                  pressedOpacity: 0.6,
                  child:
                      Text('重命名', style: TextStyle(color: Color(0xff333333))),
                  onPressed: () {
                    Navigator.pop(context);
//                    renameFile(file);
                  },
                ),
                CupertinoButton(
                  pressedOpacity: 0.6,
                  child: Text('删除', style: TextStyle(color: Color(0xff333333))),
                  onPressed: () {
                    Navigator.pop(context);
//                    deleteFile(file);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 计算以 . 开头的文件、文件夹总数
  int _calculatePointBegin(List<FileSystemEntity> fileList) {
    int count = 0;
    for (var v in fileList) {
      if (p.basename(v.path).substring(0, 1) == '.') count++;
    }

    return count;
  }

  // 计算文件夹内 文件、文件夹的数量，以 . 开头的除外
  int _calculateFilesCountByFolder(Directory path) {
    var dir = path.listSync();
    int count = dir.length - _calculatePointBegin(dir);

    return count;
  }
}
