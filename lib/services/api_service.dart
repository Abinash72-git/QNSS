import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';



import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:soapy/config/app_config.dart';
import 'package:soapy/enum/enum.dart';
import 'package:soapy/util/appconstant.dart';
import 'package:soapy/util/exception.dart';
import 'package:soapy/util/global.dart';
import 'package:soapy/widgets/warnings.dart';

class _Basic {
  const _Basic();
}

class APIService {
  // ignore: library_private_types_in_public_api
  static const _Basic basic = _Basic();
  APIService();
  static const _defaultToken = '';
  static Future<APIResp> post(
    String path, {
    required Object? data,
    bool console = true,
    bool auth = true,
    bool showNoInternet = true,
    Duration? timeout,
    Map<String, String>? params,
    bool forceLogout = true,
    required Map<String, String> headers,
  }) async {
    return await _callAPI(
      path,
      data: data,
      params: params,
      isPost: true,
      console: console,
      auth: auth,
      showNoInternet: showNoInternet,
      timeout: timeout,
      forceLogout: forceLogout,
    );
  }

  static Future<APIResp> get(
    String path, {
    bool console = true,
    Map<String, String>? params,
    bool auth = true,
    bool showNoInternet = true,
    Duration? timeout,
    bool forceLogout = true,
    Object? data,
    CancelToken? cancelToken,
    Map<String, String>? headers,
  }) async {
    return await _callAPI(
      path,
      data: data,
      isPost: false,
      cancelToken: cancelToken,
      console: console,
      auth: auth,
      params: params,
      showNoInternet: showNoInternet,
      timeout: timeout,
      forceLogout: forceLogout,
      headers: headers,
    );
  }

  static Future<APIResp> noInternetDialogue(
    String path, {
    bool isPost = false,
    Object? data,
    bool console = true,
    bool auth = true,
    bool showNoInternet = true,
    Duration? timeout,
    Map<String, String>? params,
    bool forceLogout = true,
  }) async {
    return await NoInternetScreen.show(AppGlobal.context).then((value) async {
      // if(value==true){
      if (isPost) {
        return await post(
          path,
          data: data,
          console: console,
          auth: auth,
          showNoInternet: showNoInternet,
          params: params,
          timeout: timeout,
          forceLogout: forceLogout,
          headers: {},
        );
      } else {
        return await get(
          path,
          console: console,
          auth: auth,
          showNoInternet: showNoInternet,
          params: params,
          timeout: timeout,
          forceLogout: forceLogout,
        );
      }

      // }
    });
  }

  static Future<bool> checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());
    if (!(connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi))) {
      return false;
    } else {
      bool result = await InternetConnection().hasInternetAccess;
      if (result == true) {
        return true;
      } else {
        return false;
      }
    }
  }

  static Future<bool> checkInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi))) {
      throw InternetException(type: InternetAvailabilityType.TurnOnInternet);
    }

    bool result = await InternetConnection().hasInternetAccess;
    if (result == true) {
      return true;
    } else {
      throw InternetException(type: InternetAvailabilityType.NoInternet);
    }
  }

  static Future<APIResp> _callAPI(
    String path, {
    isPost = false,
    Map<String, String>? params,
    Object? data,
    bool console = true,
    bool auth = true,
    bool showNoInternet = true,
    Duration? timeout,
    bool forceLogout = true,
    CancelToken? cancelToken,
    Map<String, String>? headers,
  }) async {
    params ??= {};
    console = kDebugMode && console;

    // Create a headers map that merges the default headers with any custom headers
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    if (auth == true) {
      // Try to get token from shared preferences if not provided in headers
      if (headers == null || !headers.containsKey('Authorization')) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString(AppConstants.token);
        if (token != null && token.isNotEmpty) {
          requestHeaders['Authorization'] = 'Bearer $token';
          print("Using token from SharedPreferences: $token");
        }
      }
    }

    // Add any custom headers from the parameter
    if (headers != null) {
      requestHeaders.addAll(headers);
      print("Added custom headers: $headers");
    }

    final String urls = "${AppConfig.instance.baseUrl}$path";
    Map<String, String> urlParameters = Map<String, String>.from(
      Uri.parse(urls).queryParameters,
    );
    urlParameters.addAll(params);
    Uri uri = Uri.parse(urls).replace(queryParameters: urlParameters);

    if (console) {
      print(urls);
      print('object--------------->');
      print(data);
      log("$uri", name: "${isPost ? "POST" : "GET"}-URL");
      log(
        "Using headers: ${jsonEncode(requestHeaders)}",
        name: "REQUEST_HEADERS",
      );
      if (data != null) {
        if (data is FormData) {
          final Map map = Map.fromEntries(data.fields);
          log(jsonEncode(map), name: "DATASET");
        } else {
          log(jsonEncode(data), name: "DATASET");
        }
      }
    }

    /// checking internet is turn on or not. it will not check internet is available or not
    final connection = await checkConnectivity();
    if (!connection) {
      return await noInternetDialogue(
        path,
        console: console,
        auth: auth,
        showNoInternet: showNoInternet,
        isPost: isPost,
        data: data,
        timeout: timeout,
        params: params,
      );
    }

    try {
      final respFun = isPost
          ? Dio().post(
              uri.toString(),
              cancelToken: cancelToken,
              data: data,
              options: Options(
                headers: requestHeaders,
              ), // Use requestHeaders here
            )
          : Dio().get(
              uri.toString(),
              data: data,
              options: Options(
                headers: requestHeaders,
              ), // Use requestHeaders here
            );

      late Response resp;
      print("Making API request to: ${uri.toString()}");

      if (timeout != null) {
        resp = await respFun.timeout(timeout);
      } else {
        resp = await respFun;
      }

      print("Received status code: ${resp.statusCode}");

      if (resp.statusCode == 200) {
        final data = resp.data;
        if (console) {
          log(jsonEncode(data), name: 'RESPONSE');
          print(data);
        }

        if (data is String) {
          APIResp res = APIResp.fromJson(json.decode(data));
          res = APIResp(
            statusCode: resp.statusCode,
            status: res.status,
            fullBody: res.fullBody,
            data: res.data,
          );
          return res;
        } else {
          APIResp res = APIResp.fromJson(data);
          res = APIResp(
            statusCode: resp.statusCode,
            status: res.status,
            fullBody: res.fullBody,
            data: res.data,
          );
          return res;
        }
      } else {
        throw APIException(type: APIErrorType.statusCode);
      }
    } on SocketException {
      // check internet is available or not.
      if (showNoInternet) {
        return await noInternetDialogue(
          path,
          console: console,
          auth: auth,
          params: params,
          timeout: timeout,
          data: data,
          isPost: isPost,
          showNoInternet: showNoInternet,
        );
      }
      throw InternetException();

      // throw InternetException(type: InternetAvailabilityType.NoInternet);
    } on FormatException {
      throw APIException(type: APIErrorType.other);
    } on TimeoutException {
      rethrow;
    } on APIException catch (e) {
      if (forceLogout && e.type == APIErrorType.auth) {
        await ExceptionHandler.showMessage(AppGlobal.context, e);
      }
      rethrow;
    } on DioException catch (e) {
      print(e.response?.data);
      if (e.response?.statusCode == 401) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Invalid Login.please try again!",
        );
      }
      if (CancelToken.isCancel(e)) {
        rethrow;
      }
      if (e.type == DioExceptionType.connectionError) {
        if (showNoInternet) {
          final result = await APIService.checkInternet();
          if (!result) {
            return await noInternetDialogue(
              path,
              console: console,
              auth: auth,
              showNoInternet: showNoInternet,
              isPost: isPost,
              data: data,
              timeout: timeout,
              params: params,
            );
          } else {
            throw APIException(
              type: APIErrorType.internalServerError,
              message: e.message ?? '',
            );
          }
        }
        throw APIException(
          type: APIErrorType.internalServerError,
          message: e.message ?? '',
        );
      }

      if (e.response?.statusCode == 404) {
        throw APIException(
          type: APIErrorType.urlNotFound,
          message: AppGlobal.urlNotExistMsg,
        );
        // throw APIException(type: APIErrorType.other);
      } else if (e.response?.statusCode == 500) {
        log(
          (e.response?.data?.toString().length ?? 0) > 1000
              ? e.response!.data!.toString().substring(0, 1000)
              : (e.response?.data?.toString() ?? "Unknown"),
          name: "INTERNAL SERVER ERROR",
        );
        print(e.response!.data);
        throw APIException(
          type: APIErrorType.internalServerError,
          message: e.response?.data ?? '',
        );
      }
      log("DIO Exception==>${e.message} ${e.type} ${e.response?.statusCode} ");
      throw APIException(type: APIErrorType.other);
    } catch (e) {
      throw APIException(type: APIErrorType.other);
    }
  }
}

class APIResp {
  final bool status;
  late final int? statusCode;
  final dynamic data;
  final dynamic fullBody;

  factory APIResp.fromJson(dynamic json) {
    return APIResp(
      status: json['success'] ?? false,
      data: json['message'] ?? json,
      fullBody: json,
    );
  }

  APIResp({this.status = false, this.data, this.fullBody, this.statusCode});
  @override
  String toString() {
    return 'Status: $status, StatusCode: $statusCode, Data: $data, FullBody: $fullBody';
  }
}
