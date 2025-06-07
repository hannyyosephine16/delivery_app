import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:del_pick/core/services/external/connectivity_service.dart';

class ConnectivityInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final connectivity = getx.Get.find<ConnectivityService>();

    if (!connectivity.isConnected) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'No internet connection',
          type: DioExceptionType.connectionError,
        ),
      );
      return;
    }

    handler.next(options);
  }
}
