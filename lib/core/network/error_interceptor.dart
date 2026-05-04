import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  ErrorInterceptor({this.onUnauthorized});

  /// Appelé quand le serveur renvoie 401 (session expirée).
  /// Branché sur le router pour rediriger vers /auth.
  final void Function()? onUnauthorized;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      onUnauthorized?.call();
    }

    // On laisse passer l'erreur — chaque repository peut la gérer localement
    handler.next(err);
  }
}
