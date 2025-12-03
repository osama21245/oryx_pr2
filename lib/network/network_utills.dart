import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../main.dart';
import '../extensions/common.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/shared_pref.dart';
import '../screens/login_screen.dart';
import '../utils/app_config.dart';
import '../utils/constants.dart';

Map<String, String> buildHeaderTokens() {
  Map<String, String> header = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    HttpHeaders.cacheControlHeader: 'no-cache',
    HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
  };

  // Check if we have a token (either from logged in user or guest user)
  String? token =
      userStore.token.isNotEmpty ? userStore.token : getStringAsync(TOKEN);

  if (token.isNotEmpty) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    print("Token being sent: $token");
  }
  log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$mBaseUrl$endPoint');
  log('URL: ${url.toString()}');
  return url;
}

Future<Response> buildHttpResponse(String endPoint,
    {HttpMethod method = HttpMethod.GET, Map? request, String? req}) async {
  if (await isNetworkAvailable()) {
    var headers = buildHeaderTokens();
    Uri url = buildBaseUrl(endPoint);
    if (kDebugMode) {
      print('URL: ${url.toString()} Method: $method');
    }
    try {
      Response response;

      if (method == HttpMethod.POST) {
        log('Request: $request');

        response = await http
            .post(url, body: req ?? jsonEncode(request), headers: headers)
            .timeout(Duration(seconds: 120), onTimeout: () => throw 'Timeout');
      } else if (method == HttpMethod.DELETE) {
        response = await delete(url, headers: headers)
            .timeout(Duration(seconds: 20), onTimeout: () => throw 'Timeout');
      } else if (method == HttpMethod.PUT) {
        response = await put(url,
                body: req ?? jsonEncode(request), headers: headers)
            .timeout(Duration(seconds: 20), onTimeout: () => throw 'Timeout');
      } else {
        response = await get(url, headers: headers)
            .timeout(Duration(seconds: 20), onTimeout: () => throw 'Timeout');
      }

      log('Response ($method): ${url.toString()} ${response.statusCode} ${response.body}');

      return response;
    } catch (e) {
      print("HTTP Error: $e");
      throw 'somethingWentWrong ${e.toString()}';
    }
  } else {
    throw errorInternetNotAvailable;
  }
}

// region Common
//
// Future handleResponse(Response response, [bool? avoidTokenError]) async {
//   if (!await isNetworkAvailable()) {
//     throw "errorInternetNotAvailable";
//   }
//   if (response.statusCode == 401) {
//     if (appStore.isLoggedIn) {
//       Map req = {
//         'email': getStringAsync(USER_EMAIL),
//         'password': "12345678",
//
//         // "12345678"
//         //getStringAsync(USER_PASSWORD),
//       };
//       print(req.toString());
//       // await logInApi(req).then((value) {
//       //   print("==>$value");
//       // }).catchError((e) {
//       //   throw TokenException(e);
//       // });
//     } else {
//       throw 'Something Went Wrong';
//     }
//   }
//
//   if (response.statusCode.isSuccessful()) {
//     print("========>${response.body}");
//     return jsonDecode(response.body);
//   } else {
//     try {
//       var body = jsonDecode(response.body);
//       throw parseHtmlString(body['message']);
//     } on Exception catch (e) {
//       log(e.toString());
//       throw "errorSomethingWentWrong";
//     }
//   }
// }

Future handleResponse(Response response) async {
  print("Response: ${response.statusCode} ${response.body}");
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }

  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    var string = await (isJsonValid(response.body));
    print("jsonDecode(response.body)$string");
    if (string!.isNotEmpty) {
      if (string.toString().contains("Unauthenticated")) {
        // Only clear data and redirect if user was previously logged in
        // If already not logged in (guest mode), just throw the error
        bool wasLoggedIn = appStore.isLoggedIn;

        await removeKey(IS_LOGIN);
        await removeKey(USER_ID);
        await removeKey(FIRSTNAME);
        await removeKey(LASTNAME);
        await removeKey(PHONE_NUMBER);
        await removeKey(GENDER);
        await removeKey(IS_OTP);

        userStore.clearUserData();
        userStore.setLogin(false);

        // Only redirect to login if user was previously logged in
        // Guest users should not be redirected
        if (wasLoggedIn) {
          push(LoginScreen());
        } else {
          // For guest users, just throw the error so calling code can handle it
          throw string;
        }
      } else {
        throw string;
      }
    } else {
      throw 'Please try again later.';
    }
  }
}

enum HttpMethod { GET, POST, DELETE, PUT }

class TokenException implements Exception {
  final String message;

  const TokenException([this.message = ""]);

  @override
  String toString() => "FormatException: $message";
}

Future<String?> isJsonValid(json) async {
  try {
    var f = jsonDecode(json) as Map<String, dynamic>;
    return f['message'];
  } catch (e) {
    log(e.toString());
    return "";
  }
}

/// Redirect to given widget without context
// Future<T?> push<T>(
//     Widget widget, {
//       bool isNewTask = false,
//       PageRouteAnimation? pageRouteAnimation,
//       Duration? duration,
//     }) async {
//   if (isNewTask) {
//     return await Navigator.of(getContext).pushAndRemoveUntil(
//       buildPageRoute(
//           widget, pageRouteAnimation ?? pageRouteAnimationGlobal, duration),
//           (route) => false,
//     );
//   } else {
//     if (getContext != null) {
//       return await Navigator.of(getContext).push(
//         buildPageRoute(
//             widget, pageRouteAnimation ?? pageRouteAnimationGlobal, duration),
//       );
//     }
//   }
// }
// /// Dispose current screen or close current dialog
// void pop([Object? object]) {
//   if (Navigator.canPop(getContext)) Navigator.pop(getContext, object);
// }

Future<MultipartRequest> getMultiPartRequest(String endPoint,
    {String? baseUrl}) async {
  String url = baseUrl ?? buildBaseUrl(endPoint).toString();
  log(url);
  return MultipartRequest('POST', Uri.parse(url));
}

Future<MultipartRequest> updateMultiPartRequest(String endPoint,
    {String? baseUrl}) async {
  String url = baseUrl ?? buildBaseUrl(endPoint).toString();
  log(url);
  return MultipartRequest('post', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest,
    {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  http.Response response =
      await http.Response.fromStream(await multiPartRequest.send());
  print("Result:${response.statusCode} ${response.body}");
  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body);
  } else {
    onError?.call(errorSomethingWentWrong);
  }
}

/// returns true if network is available
Future<bool> isNetworkAvailable() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

/// returns true if connected to mobile
Future<bool> isConnectedToMobile() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult == ConnectivityResult.mobile;
}

/// returns true if connected to wifi
Future<bool> isConnectedToWiFi() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult == ConnectivityResult.wifi;
}
