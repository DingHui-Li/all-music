import 'dart:convert';

import 'package:allMusic/api/get/wy.dart';
import 'package:dio/dio.dart';

import 'get/kg.dart';
import 'get/qq.dart';

search(String keyword) async {
  List musics = List();

  Response qq_res = await QQ.search(keyword);
  var qq = _qq_format(qq_res.data);
  musics.addAll(qq);
  Response wy_res = await WY.search(keyword);
  var wy = _wy_format(wy_res.data);

  musics.addAll(wy);
  Response kg_res = await KG.search(keyword);
  var kg = _kg_format(kg_res.data);

  musics.addAll(kg);
  return musics;
}

_qq_format(String jsonStr) {
  var data = json.decode(jsonStr);
  List list = data['data']['song']['list'];
  return list.length > 0
      ? list.map((el) => {
            'name': el['songname'], //歌曲名
            'url': el['songmid'], //获取播放地址
            'pubTime': el['pubtime'], //发布时间
            'duration': el['interval'], //时长
            'singer': el['singer']
                .map((e) => {
                      'id': e['id'].toString(),
                      'name': e['name'],
                      'img': e['mid']
                    })
                .toList(), //歌手【】数组
            'album': {
              'id': el['albummid'],
              'name': el['albumname'],
              'img': //封面
                  'http://y.gtimg.cn/music/photo_new/T002R180x180M000${el['albummid']}.jpg'
            },
            'source': 'qq'
          })
      : list;
}

_wy_format(String jsonStr) {
  var data = json.decode(jsonStr);
  List list = data['result']['songs'];
  return list != null
      ? list.map((el) => {
            'name': el['name'], //歌曲名
            'url':
                'https://music.163.com/song/media/outer/url?id=${el['id']}', //获取播放地址
            'pubTime': el['album']['publishTime'], //发布时间
            'duration': el['duration'], //时长
            'singer': el['artists']
                .map((e) => {
                      'id': e['id'].toString(),
                      'name': e['name'],
                      'img': e['img1v1Url']
                    })
                .toList(), //歌手【】数组
            'album': {
              'id': el['album']['id'],
              'name': el['album']['name'],
              'img': el['album']['artist']['img1v1Url']
            }, //专辑
            'source': 'wy'
          })
      : [];
}

_kg_format(jsonStr) {
  var data = json.decode(jsonStr);
  List list = data['data']['info'];
  return list.length > 0
      ? list.map((el) => {
            'name': el['songname'], //歌曲名
            'url': {'hash': el['hash'], 'albumid': el['album_id']}, //获取播放地址
            'pubTime': '', //发布时间
            'duration': el['duration'], //时长
            'singer': el['singername'], //歌手【】数组
            'album': {
              'id': el['album_id'],
              'name': el['album_name'],
              'img': ''
            }, //专辑
            'source': 'kg'
          })
      : [];
}
