part of 'service.dart';

class RequestInterceptor extends Interceptor {
  @override
  FutureOr<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) {
    final authToken = AuthenticationRepository.instance.authToken;

    if (authToken != null && authToken.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $authToken";
    } else {
      logger.shout("No auth token found");
    }

    options.headers['Accept'] = 'application/json';
    // options.headers['role'] = 'user';
    super.onRequest(options, handler);
  }

  Future<String?> getValidAuthToken() async {
    String? authToken = AuthenticationRepository.instance.authToken;

    if (authToken == null || authToken.isEmpty) {
      // Try to refresh the token
      authToken = await refreshAuthToken();
    }

    return authToken;
  }

  Future<String?> refreshAuthToken() async {
    final appPrefs = service<AppPreferences>();

    return await appPrefs.getAuthData().then((authData) {
      return authData?.accessToken;
    });
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final newToken = await refreshAuthToken();
      if (newToken != null) {
        // Retry the request with the new token
        err.requestOptions.headers["Authorization"] = "Bearer $newToken";
        return handler.resolve(await Http.dio.fetch(err.requestOptions));
      } else {
        // If refresh failed, logout the user
        AuthenticationRepository.instance.logout();
      }
    }
    super.onError(err, handler);
  }
}

///[Deserializer] takes in data and transform it to desired type[X]
typedef Deserializer<X> = X Function(dynamic data);
typedef HttpResult<X> = Future<MultipleResult<X>>;

class Http {
  static final Dio dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: BASE_URL,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(milliseconds: TIMEOUT),
      sendTimeout: const Duration(milliseconds: TIMEOUT),
      receiveTimeout: const Duration(milliseconds: TIMEOUT),
    ));
    dio.interceptors.addAll([
      RateLimitInterceptor(dio),
      RequestInterceptor(),
      if (kDebugMode)
        HttpFormatter(
          httpLoggerFilter: () => true,
        ),
    ]);
    return dio;
  }
  static HttpResult<T> get<T>(
    String url, {
    Options? options,
    Deserializer<T>? deserializer,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final res =
          await dio.get(url, options: options, queryParameters: queryParams);

      return MultipleResult.onSuccess(
        data: deserializer != null ? deserializer(res.data) : res.data,
      );
    } on DioException catch (error) {
      if (kDebugMode) print("DIO Error: $error");
      return MultipleResult.onError(
        error: ErrorHandler(error).handle(),
      );
    } on Exception catch (error) {
      logger.info(error);
      return MultipleResult.onError(
        error: Failure(error: "Unexpected error occurred"),
      );
    }
  }

  static HttpResult<T> post<T>(
    String url,
    dynamic data, {
    Options? options,
    Deserializer<T>? deserializer,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      if (kDebugMode) logger.info(data);
      final res = await dio.post(url,
          data: data, options: options, queryParameters: queryParams);
      return MultipleResult.onSuccess(
        data: deserializer != null ? deserializer(res.data) : res.data,
      );
    } on DioException catch (error) {
      return MultipleResult.onError(
        error: ErrorHandler(error).handle(),
      );
    } on Exception catch (error) {
      if (kDebugMode) print(error);
      logger.info(error);
      return MultipleResult.onError(
        error: Failure(error: "Unexpected error occurred"),
      );
    }
  }

  static HttpResult<T> put<T>(
    String url,
    dynamic data, {
    Options? options,
    Deserializer<T>? deserializer,
  }) async {
    try {
      final res = await dio.put(url, data: data, options: options);
      return MultipleResult.onSuccess(
        data: deserializer != null ? deserializer(res.data) : res.data,
      );
    } on DioException catch (error) {
      return MultipleResult.onError(
        error: ErrorHandler(error).handle(),
      );
    } on Exception catch (error) {
      logger.info(error);
      return MultipleResult.onError(
        error: Failure(error: "Unexpected error occurred"),
      );
    }
  }

  static HttpResult<T> patch<T>(
    String url,
    dynamic data, {
    Options? options,
    Deserializer<T>? deserializer,
  }) async {
    try {
      final res = await dio.patch(url, data: data, options: options);
      return MultipleResult.onSuccess(
        data: deserializer != null ? deserializer(res.data) : res.data,
      );
    } on DioException catch (error) {
      return MultipleResult.onError(
        error: ErrorHandler(error).handle(),
      );
    } on Exception catch (error) {
      logger.info(error);
      return MultipleResult.onError(
        error: Failure(error: "Unexpected error occurred"),
      );
    }
  }

  static HttpResult<T> delete<T>(
    String url, {
    Options? options,
    dynamic data,
    Deserializer<T>? deserializer,
  }) async {
    try {
      final res = await dio.delete(url, data: data, options: options);
      return MultipleResult.onSuccess(
        data: deserializer != null ? deserializer(res.data) : res.data,
      );
    } on DioException catch (error) {
      return MultipleResult.onError(
        error: ErrorHandler(error).handle(),
      );
    } on Exception catch (error) {
      logger.info(error);
      return MultipleResult.onError(
        error: Failure(error: "Unexpected error occurred"),
      );
    }
  }
}
