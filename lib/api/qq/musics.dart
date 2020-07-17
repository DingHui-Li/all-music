import 'package:allMusic/api/dio.dart';
import 'package:dio/dio.dart';

Dio dio = myDio.getInstance();
Future<Response> getRandomMusics() {
  return dio.get(
      'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?g_tk=5381&uin=0&format=json&inCharset=utf-8&outCharset=utf-8¬ice=0&platform=h5&needNewCode=1&tpl=3&page=detail&type=top&topid=36&_=1520777874472');
}

Future<Response> getHot() {
  return dio.get('https://c.y.qq.com/splcloud/fcgi-bin/gethotkey.fcg');
}

Future<Response> smartAsso(String keyword) {
  if (keyword.trim().length > 0) {
    return dio.get(
        'https://c.y.qq.com/splcloud/fcgi-bin/smartbox_new.fcg?is_xml=0&key=${keyword.trim()}');
  }
  return Future(() {
    return Response(statusCode: -1);
  });
}
