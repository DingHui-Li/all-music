import 'package:allMusic/api/dio.dart';
import 'package:dio/dio.dart';

class KG{
  static Dio dio = myDio.getInstance();

  static Future<Response>search(String keyword){
    return dio.get('http://mobilecdn.kugou.com/api/v3/search/song?format=json&keyword=${keyword}&page=1&pagesize=20&showtype=1');
  }
}