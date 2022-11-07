import 'package:dio/dio.dart' as Dio;

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:platform_nomros/services/dio.dart';

import '../model/user.dart';

class Auth extends ChangeNotifier{

  bool _isLoggedIn = false;
  late User _user;

  late String _token;
  final storage = new FlutterSecureStorage();

  bool get authentication => _isLoggedIn;
  User get user => _user;

  String get token => _token;

  void login(Map creds) async{

    print("aaaaaaaa ${creds}");

    try{

      Dio.Response response = await dio().post('/sanctum/token', data: creds);
      print("aaaaaa respons ${response.data}");
      Map j = response.data;
      print(response.data);

      if(j['status'] == "error"){
        Fluttertoast.showToast(msg: j['error'], toastLength: Toast.LENGTH_LONG);
      }else if(j['status'] == "success"){

        String tt = j['token'];
        this._token = tt;
        print(tt);
        this.tryToken(tt);

      }else{
        Fluttertoast.showToast(msg: response.toString(), toastLength: Toast.LENGTH_SHORT);
      }

    }catch(e){
      print(e);
    }

  }

  void tryToken(String token) async{

    print("tryToken ${token}");

    if(token == null){
      return;
    }else{
      try{

        print("aaaaaaaaatttttt $token");
        Dio.Response response = await dio().get('/user', options: Dio.Options(headers: {'authorization': 'Bearer $token'}));
        print("tryToken response ${response.data}");
        this._isLoggedIn = true;
        this._user = User.fromJson(response.data);
        this._token = token;
        print(_user);
        this.storeToken(token);
        notifyListeners();

      }catch(e){
        print(e);
      }
    }



  }


  void storeToken(String t){
    this.storage.write(key: 'token', value: t);
  }

  void logout() async{

    try{
      Dio.Response response = await dio().get("/user/revoke", options: Dio.Options(headers: {'authorization': 'Bearer $_token'}));
      cleanUp();
      notifyListeners();
    }catch(e){
      print(e);
    }

  }


  void cleanUp() async{
    this._user = User();
    this._isLoggedIn = false;
    this._token = '';
    await storage.delete(key: 'token');
  }

}