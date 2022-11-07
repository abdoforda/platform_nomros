
import 'package:device_info_plus/device_info_plus.dart';

import 'package:dio/dio.dart' as Dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:platform_nomros/model/feature/list_lang.dart';
import 'package:platform_nomros/screen/verification2.dart';
import 'package:provider/provider.dart';
import 'package:unique_identifier/unique_identifier.dart';

import 'package:universal_io/io.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/feature/list_years.dart';
import '../services/auth.dart';
import '../services/dio.dart';

class Signup1Page extends StatefulWidget {
  @override
  _Signup1PageState createState() => _Signup1PageState();
}

class _Signup1PageState extends State<Signup1Page> {

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  FirebaseAuth auth = FirebaseAuth.instance;

  bool _isLoading = false;


  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;


  Color _backgroundColor = Color(0xFFA5C4BF);
  Color _underlineColor = Color(0xFFCCCCCC);
  Color _buttonColor = Color(0xFF1AA18D);

  Color _textColor = Color(0xFFFFFFFF);

  String? _valYear;
  String? _valLang;
  String? _imeiNo;


  var _valName = TextEditingController();
  var _valPhone = TextEditingController();
  var _valPassword = TextEditingController();
  var _valCPassword = TextEditingController();

  List<ListYears> listY = [];
  List<ListLang> listl = [];

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


    listY.add(ListYears(id: 1,name: "الصف الأول الثانوي"));
    listY.add(ListYears(id: 2,name: "الصف الثاني الثانوي - علمي"));
    listY.add(ListYears(id: 3,name: "الصف الثاني الثانوي - أدبي"));
    listY.add(ListYears(id: 4,name: "الصف الثالث الثانوي - علمي علوم"));
    listY.add(ListYears(id: 5,name: "الصف الثالث الثانوي - علمي رياضه"));
    listY.add(ListYears(id: 6,name: "الصف الثالث الثانوي - أدبي"));

    listl.add(ListLang(id: 1,name: "اللغة الفرنسية"));
    listl.add(ListLang(id: 2,name: "اللغة الألمانية"));
    listl.add(ListLang(id: 3,name: "اللغة الإيطالية"));
    listl.add(ListLang(id: 4,name: "اللغة الأسبانية"));


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
          value: Platform.isIOS
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
          child: ListView(
            padding: EdgeInsets.fromLTRB(32, 32, 32, 24),
            children: [
              SizedBox(height: 24,),
              Container(
                child: Image.asset('assets/images/logo_dark.png', height: 120),
              ),
              SizedBox(height: 24,),
              Card(
                color: _buttonColor,
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: Icon(Icons.keyboard_arrow_down),
                      dropdownColor: _buttonColor,
                      iconEnabledColor: _textColor,
                      hint: Text("السنة الدراسية", style: TextStyle(color: _textColor)),
                      value: _valYear,
                      items: listY.map((value) {
                        return DropdownMenuItem<String>(
                          child: Text(value.name.toString(), style: TextStyle(color: _textColor)),
                          value: value.id.toString(),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _valYear = value!;
                          print("aaaaaa ${value}");
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Card(
                color: _buttonColor,
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: Icon(Icons.keyboard_arrow_down),
                      dropdownColor: _buttonColor,
                      iconEnabledColor: _textColor,
                      hint: Text("اللغة الأجنبية الثانية", style: TextStyle(color: _textColor)),
                      value: _valLang,
                      items: listl.map((value) {
                        return DropdownMenuItem<String>(
                          child: Text(value.name.toString(), style: TextStyle(color: _textColor)),
                          value: value.id.toString(),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _valLang = value!;
                          print("aaaaa ${_valLang}");
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                controller: _valName,
                keyboardType: TextInputType.text,
                style: TextStyle(color: _textColor),
                cursorColor: _textColor,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: _textColor, width: 2.0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: _underlineColor),
                    ),
                    labelText: 'أسمك الرباعي',
                    labelStyle: TextStyle(color: _textColor)),
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                controller: _valPhone,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: _textColor),
                cursorColor: _textColor,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: _textColor, width: 2.0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: _underlineColor),
                    ),
                    labelText: 'رقم الموبيل',
                    labelStyle: TextStyle(color: _textColor)),
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                controller: _valPassword,
                obscureText: _obscureText,
                style: TextStyle(color: _textColor),
                cursorColor: _textColor,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: _textColor, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _underlineColor),
                  ),
                  labelText: 'كلمة المرور',
                  labelStyle: TextStyle(color: _textColor),
                  suffixIcon: IconButton(
                      icon: Icon(_iconVisible, color: _textColor, size: 20),
                      onPressed: () {
                        _toggleObscureText();
                      }),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                controller: _valCPassword,
                obscureText: _obscureText,
                style: TextStyle(color: _textColor),
                cursorColor: _textColor,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: _textColor, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _underlineColor),
                  ),
                  labelText: 'تأكيد كلمة المرور',
                  labelStyle: TextStyle(color: _textColor),
                  suffixIcon: IconButton(
                      icon: Icon(_iconVisible, color: _textColor, size: 20),
                      onPressed: () {
                        _toggleObscureText();
                      }),
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
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    )),
                  ),
                  onPressed: () async {

                    if(_isLoading){
                      return;
                    }

                    if(_valYear == null){
                      Fluttertoast.showToast(msg: "إختر السنة الدراسية", toastLength: Toast.LENGTH_LONG);
                      return;
                    }

                    if(_valLang == null){
                      Fluttertoast.showToast(msg: "أختر اللغة الاجنبية الثانية", toastLength: Toast.LENGTH_LONG);
                      return;
                    }

                    if(_valName.text.isEmpty){
                      Fluttertoast.showToast(msg: "أكتب إسمك الرباعي", toastLength: Toast.LENGTH_LONG);
                      return;
                    }

                    int count = 0;
                    var searchFor = _valName.text.trim().split(" ");
                    if(searchFor.length != 4){
                      Fluttertoast.showToast(msg: "الإسم يجب ان يكون رباعي", toastLength: Toast.LENGTH_LONG);
                      return;
                    }

                    if(_valPhone.text.length != 11 || !isNumeric(_valPhone.text)){
                      Fluttertoast.showToast(msg: "إدخل رقم الموبيل بشكل صحيح", toastLength: Toast.LENGTH_LONG);
                      return;
                    }

                    if(_valPassword.text.isEmpty){
                      Fluttertoast.showToast(msg: "أكتب كلمة المرور", toastLength: Toast.LENGTH_LONG);
                      return;
                    }

                    if(_valPassword.text != _valCPassword.text){
                      Fluttertoast.showToast(msg: "كلمة المرور غير متطابقة", toastLength: Toast.LENGTH_LONG);
                      return;
                    }



                    setState(() { _isLoading = true; });

                    Map creds = {
                      'name': _valName.text,
                      'phone': _valPhone.text,
                      'year': _valYear,
                      'lang2': _valLang,
                      'password': _valPassword.text,
                      'c_password': _valCPassword.text,
                      'device_id': _imeiNo,
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

                        print("aaaaaaaa codeSent");
                        var t = await Navigator.push(context, CupertinoPageRoute(builder: (context) => Verification2Page(verificationId, _valPhone.text, creds, false, "signup")));
                        if(t.toString() == "login"){
                          print("aaaaaaaaaaaa login signup1");
                          Navigator.pop(context);
                        }
                        setState(() {
                          _isLoading = false;
                        });

                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        Navigator.pop(context);
                      },
                    );

                    //register(creds);
                    print(creds);

                    //Provider.of<Auth>(context, listen: false).login(creds);


                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: _isLoading ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ) :  Text(
                      'إنشاء الحساب',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textColor),
                      textAlign: TextAlign.center,
                    ),
                  )),
              SizedBox(
                height: 60,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text('هل تمتلك حساب؟ إضغط هنا',
                      style: TextStyle(fontSize: 15, color: _textColor)),
                ),
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
