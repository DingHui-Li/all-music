import 'package:dio/dio.dart';

class myDio {
  static Dio dio;
  static _init() {
    var options = BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      responseType: ResponseType.plain,
      validateStatus: (status) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
    );
    dio = Dio(options);
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (Options options) async {
      dio.interceptors.requestLock.lock();
      //do something
      dio.interceptors.requestLock.unlock();
      return options;
    }));
  }

  static Dio getInstance() {
    if (dio == null) {
      _init();
    }
    return dio;
  }
}
