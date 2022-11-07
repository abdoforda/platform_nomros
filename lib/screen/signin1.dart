import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:platform_nomros/screen/forgot_password2.dart';

import 'package:platform_nomros/screen/signup1.dart';
import 'package:platform_nomros/screen/verification2.dart';
import 'package:platform_nomros/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signin1Page extends StatefulWidget {
  @override
  _Signin1PageState createState() => _Signin1PageState();
}

class _Signin1PageState extends State<Signin1Page> {

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  FirebaseAuth auth = FirebaseAuth.instance;

  final storage = new FlutterSecureStorage();
  var _phone = TextEditingController();
  var _password = TextEditingController();
  String? _imeiNo;
  bool _isLoading = false;
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  Color _backgroundColor = Color(0xFFA5C4BF);
  Color _underlineColor = Color(0xFFCCCCCC);
  Color _buttonColor = Color(0xFF1AA18D);

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  @override
  void initState() {
    checkToken();
    this._phone.text = "";
    this._password.text = "";
    _getPlatform();
    super.initState();
  }

  void _getPlatform() async{

    try {

      if (Platform.isAndroid) {
        String? identifier = await UniqueIdentifier.serial;
        _imeiNo = identifier;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _imeiNo = iosInfo.identifierForVendor.toString();
      }else{
        _imeiNo = "123456789abcdefg";
      }

    } catch (e) {
      _imeiNo = "123456789abcdefgcatch";
    }

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _backgroundColor,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Platform.isIOS?SystemUiOverlayStyle.light:SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light
          ),
          child: ListView(
            padding: EdgeInsets.fromLTRB(32, 72, 32, 24),
            children: [
              Container(
                child: Image.asset('assets/images/logo_dark.png', height: 120),
              ),
              SizedBox(
                height: 32,
              ),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: _underlineColor),
                    ),
                    labelText: 'رقم هاتفك',
                    labelStyle: TextStyle(color: Colors.white)),
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                controller: _password,
                obscureText: _obscureText,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _underlineColor),
                  ),
                  labelText: 'كلمة المرور',
                  labelStyle: TextStyle(color: Colors.white, fontFamily: 'arabic'),
                  suffixIcon: IconButton(
                      icon: Icon(_iconVisible, color: Colors.white, size: 20),
                      onPressed: () {
                        _toggleObscureText();
                      }),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ForgotPassword2Page()));
                },
                child: Text('هل نسيت كلمة المرور؟ إضغط للإستعادة',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13
                    ),
                    textAlign: TextAlign.right
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) => _buttonColor,
                    ),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        )
                    ),
                  ),
                  onPressed: () {

                    if(_isLoading){
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                    });


                    Map creds = {
                      'email': _phone.text,
                      'password': _password.text,
                      'device_name': _imeiNo,
                      'device_id': _imeiNo,
                    };

                    Provider.of<Auth>(context, listen: false).login(creds);

                    new Future.delayed(Duration(seconds: 3), (){
                      setState(() {
                        _isLoading = false;
                      });
                    });

                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: _isLoading ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ) : Text(
                      'دخول',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
              ),
              SizedBox(
                height: 60,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    //Fluttertoast.showToast(msg: 'Click signup', toastLength: Toast.LENGTH_SHORT);
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => Signup1Page()));
                  },
                  child: Text('لا تمتلك حساب؟ إضغط هنا', style: TextStyle(
                      fontSize: 15, color: Colors.white
                  )),
                ),
              )
            ],
          ),
        )
    );

  }

  void checkToken() async {
    String? token = await storage.read(key: 'token');
    print("aaaaaa ${token}");
    if(token == null){

    }else{
      Provider.of<Auth>(context, listen: false).tryToken(token.toString());
    }

  }


}
