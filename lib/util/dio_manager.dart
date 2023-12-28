import 'package:dio/dio.dart';

class DioManager {
  static final DioManager _instance = DioManager._internal();
  late Dio _dio;
  final BaseOptions _options = BaseOptions(
    baseUrl: 'https://example.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  );

  factory DioManager() {
    return _instance;
  }

  DioManager._internal() {
    _dio = Dio(_options);

    // 添加日志拦截器
    _dio.interceptors.add(LogInterceptor(responseBody: true));

    // 添加其他拦截器或者配置...
  }

  // 设置自定义的Header
  void setHeaders(Map<String, dynamic> headers) {
    _dio.options.headers = headers;
  }

  // 处理GET请求
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters,CancelToken? cancelToken}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // 处理POST请求
  Future<Response> post(String path, {data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // 错误处理
  Response _handleError(DioException e) {
    // 可以根据错误类型或者状态码来定制化处理
    print(e.message);
    return e.response!;
  }

  // 取消请求
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
