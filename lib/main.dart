import 'package:allMusic/util/hive.dart';
import 'package:allMusic/view/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'channel/backDesktop.dart';

void main() async {
  await hiveInit();
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('app').listenable(keys: ['dark']),
      builder: (BuildContext context, box, Widget child) {
        bool isDark = box.get('dark', defaultValue: false);
        return MaterialApp(
            title: 'Flutter Demo',
            theme: isDark
                ? ThemeData.dark()
                : ThemeData(
                    primarySwatch: Colors.blue,
                    primaryColor: Colors.blueAccent,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
            darkTheme: ThemeData.dark(),
            home: WillPopScope(
              onWillPop: () async {
                // AndroidBackTop.backDeskTop(); //设置为返回不退出app
                // return false; //一定要return false
                return true;
              },
              child: Home(),
            ));
      },
    );
  }
}
