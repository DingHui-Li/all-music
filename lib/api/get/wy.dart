import 'package:allMusic/api/dio.dart';
import 'package:dio/dio.dart';

class WY{
  static Dio dio = myDio.getInstance();

  static Future<Response>search(String keyword){
    return dio.get('http://musicapi.leanapp.cn/search?keywords=${keyword}&limit=10');
  }
}