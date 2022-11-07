import 'package:dio/dio.dart';
import 'package:platform_nomros/config/constant.dart';
import 'package:platform_nomros/services/auth.dart';
import 'package:provider/provider.dart';

Dio dio(){
  Dio dio = new Dio();
  // Set default configs
  dio.options.baseUrl = urlStatic;
  dio.options.headers['accept'] = "*/*";
  return dio;
}

Dio dioAuth(context){

  String token = Provider.of<Auth>(context, listen: false).token;
  print("aaaaaaa: ${token}");
  Dio dio = new Dio();
  // Set default configs
  dio.options.baseUrl = urlStatic;
  dio.options.headers['accept'] = "*/*";
  dio.options.headers['authorization'] = "Bearer ${token}";
  return dio;
}

