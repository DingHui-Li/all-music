import 'package:allMusic/api/dio.dart';
import 'package:dio/dio.dart';

class QQ {
  static Dio dio = myDio.getInstance();
  static Future<Response> getRandomMusics() {
    return dio.get(
        'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?g_tk=5381&uin=0&format=json&inCharset=utf-8&outCharset=utf-8¬ice=0&platform=h5&needNewCode=1&tpl=3&page=detail&type=top&topid=36&_=1520777874472');
  }

  static Future<Response> getHot() {
    return dio.get('https://c.y.qq.com/splcloud/fcgi-bin/gethotkey.fcg');
  }

  static Future<Response> smartAsso(String keyword) {
    if (keyword.trim().length > 0) {
      return dio.get(
          'https://c.y.qq.com/splcloud/fcgi-bin/smartbox_new.fcg?is_xml=0&key=${keyword.trim()}');
    }
    return Future(() {
      return Response(statusCode: -1);
    });
  }

  static Future<Response> search(String keyword) {
    return dio.get(
        'https://c.y.qq.com/soso/fcgi-bin/client_search_cp?w=${keyword.trim()}&format=json');
  }
}
