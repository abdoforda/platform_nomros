import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:platform_nomros/screen/verification2.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword2Page extends StatefulWidget {
  @override
  _ForgotPassword2PageState createState() => _ForgotPassword2PageState();
}

class _ForgotPassword2PageState extends State<ForgotPassword2Page> {

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Color _gradientTop = Color(0xFF039be6);
  Color _gradientBottom = Color(0xFF0299e2);
  Color _mainColor = Color(0xFF0181cc);
  Color _underlineColor = Color(0xFFCCCCCC);
  var _valPhone = TextEditingController();
  String? _imeiNo;
  bool _isLoading = false;

  @override
  void initState() {
    _getPlatform();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Platform.isIOS?SystemUiOverlayStyle.light:SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light
          ),
          child: Stack(
            children: <Widget>[
              // top blue background gradient
              Container(
                height: MediaQuery.of(context).size.height / 3.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [_gradientTop, _gradientBottom],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
              ),
              // set your logo here
              Container(
                  margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height / 20, 0, 0),
                  alignment: Alignment.topCenter,
                  child: Image.asset('assets/images/logo_dark.png', height: 120)),
              ListView(
                children: <Widget>[
                  // create form login
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(32, MediaQuery.of(context).size.height / 3.5 - 72, 32, 0),
                    color: Colors.white,
                    child: Container(
                        margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            Center(
                              child: Text(
                                'نسيت كلمة المرور',
                                style: TextStyle(
                                    color: _mainColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                'لتتمكن من إستعادة كلمة المرور اكتب رقم الموبيل وسوف يصلك كود تأكيد',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _valPhone,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[600]!)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: _underlineColor),
                                  ),
                                  labelText: 'رقم الموبيل',
                                  labelStyle: TextStyle(color: Colors.grey[700])),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.maxFinite,
                              child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) => _mainColor,
                                    ),
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        )
                                    ),
                                  ),
                                  onPressed: () async {


                                    if(_valPhone.text.length != 11 || !isNumeric(_valPhone.text)){
                                      Fluttertoast.showToast(msg: "إدخل رقم الموبيل بشكل صحيح", toastLength: Toast.LENGTH_LONG);
                                      return;
                                    }

                                    setState(() { _isLoading = true; });


                                    Map creds = {
                                      'phone': _valPhone.text,
                                      'device_id': _imeiNo,
                                      'device_name': _imeiNo,
                                    };


                                    await FirebaseAuth.instance.verifyPhoneNumber(
                                      phoneNumber: '+2'+_valPhone.text,
                                      timeout: const Duration(seconds: 120),
                                      verificationCompleted: (PhoneAuthCredential credential) async {},
                                      verificationFailed: (FirebaseAuthException e) {
                                        Fluttertoast.showToast(msg: e.code, toastLength: Toast.LENGTH_SHORT);
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      },
                                      codeSent: (String verificationId, int? resendToken) async {

                                        var t = await Navigator.push(context, CupertinoPageRoute(builder: (context) => Verification2Page(verificationId, _valPhone.text, creds, false, "forgot")));
                                        if(t.toString() == "login"){
                                          Navigator.pop(context);
                                        }
                                        setState(() {
                                          _isLoading = false;
                                        });

                                      },
                                      codeAutoRetrievalTimeout: (String verificationId) {
                                        Navigator.pop(context);
                                        //Navigator.push(context, CupertinoPageRoute(builder: (context) => Verification2Page(verificationId, _valPhone.text, creds, true, "forgot")));
                                      },
                                    );


                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: _isLoading ? CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ) : Text(
                                      'إستعادة كلمة المرور',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                              ),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // create sign up link
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.arrow_back, size: 16, color: _mainColor),
                          Text(
                            'رجوع',
                            style: TextStyle(
                                color: _mainColor,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )
            ],
          ),
        )
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

}
