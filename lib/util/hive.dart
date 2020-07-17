import 'package:hive/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';

Future hiveInit() {
  return Future(() async {
    await Hive.initFlutter();
    var box = await Hive.openBox('play'); //播放相关数据
    var box2 = await Hive.openBox('app'); //app相关设置
    //box.put('list', []); //播放列表
    //box.put('index', 0); //当前播放的下标
    box.put('action', '');

    box2.put('dark', false);
    box2.put('route', {'action': 'push', 'route': '/'});
  });
}

Map routes = {'/': 0, '/search': 1};
