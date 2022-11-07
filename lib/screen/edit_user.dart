
import 'package:device_info_plus/device_info_plus.dart';

import 'package:dio/dio.dart' as Dio;

import 'package:flutter/cupertino.dart';
import 'package:platform_nomros/model/feature/list_lang.dart';
import 'package:platform_nomros/screen/home1.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:platform_nomros/model/home_class.dart';
import 'package:universal_io/io.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/feature/list_years.dart';

import '../services/dio.dart';

class EditU extends StatefulWidget {
  Home? home;
  EditU(this.home);

  @override
  _EditUState createState() => _EditUState();
}

class _EditUState extends State<EditU> {

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  bool _isLoading = false;

  Home home2 = Home();

  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  Color _backgroundColor = Color(0xFF3FB5E4);
  Color _underlineColor = Color(0xFFCCCCCC);
  Color _buttonColor = Color(0xFF005288);
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

  _valYear = widget.home!.user!.yearId.toString();
  _valLang = widget.home!.user!.langId.toString();


     _valName.text = widget.home!.user!.name.toString();
     _valPhone.text = widget.home!.user!.phone.toString();

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
              Container(
                child: Image.asset('assets/images/logo_dark.png', height: 120),
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
                enableInteractiveSelection: false,
                enabled: false,
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
                  labelText: 'كلمة المرور جديدة',
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


                    if(_valPassword.text != _valCPassword.text){
                      Fluttertoast.showToast(msg: "كلمة المرور غير متطابقة", toastLength: Toast.LENGTH_LONG);
                      return;
                    }

                    setState(() { _isLoading = true; });

                    Map creds = {
                      'name': _valName.text,
                      'year': _valYear,
                      'lang2': _valLang,
                      'password': _valPassword.text,
                      'c_password': _valCPassword.text,
                      'device_id': _imeiNo,
                    };


                    register(creds);
                    print(creds);

                    //Provider.of<Auth>(context, listen: false).login(creds);


                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: _isLoading ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ) :  Text(
                      'تعديل',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textColor),
                      textAlign: TextAlign.center,
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text('رجوع',
                      style: TextStyle(fontSize: 15, color: _textColor, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        )
    );
  }



  void register(Map creds) async {

    Dio.Response res = await dioAuth(context).post('/update_profile', data: creds);
    Map j = res.data;
    print(res.data);

    if(j['status'] == "error"){
      Fluttertoast.showToast(msg: j['error'], toastLength: Toast.LENGTH_LONG);
    }else if(j['status'] == "success"){
      Fluttertoast.showToast(msg: "تم تحديث بياناتك بنجاح", toastLength: Toast.LENGTH_LONG);
      //widget.home = j['home'];
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
          builder: (context) => Home1Page()), (route) => false);
    }else{
      Fluttertoast.showToast(msg: j['error'], toastLength: Toast.LENGTH_SHORT);
    }

    setState(() { _isLoading = false; });


  }


}
