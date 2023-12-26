import 'package:dio/dio.dart';

class DioManager {
  static final DioManager _instance = DioManager._internal();
  late Dio _dio;

  factory DioManager() {
    return _instance;
  }

  DioManager._internal() {
    _dio = Dio();
    _dio.options = BaseOptions(
      baseUrl: 'https://example.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    );
    // 添加拦截器等
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {data, Map<String, dynamic>? queryParameters}) async {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  // 其他方法...
}
