import 'package:dio/dio.dart' as Dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../services/dio.dart';

class Verification2Page extends StatefulWidget {
  String vId;
  String phoneNumber;
  Map creds;
  bool is_out;
  String type;
  Verification2Page(this.vId, this.phoneNumber, this.creds, this.is_out, this.type);
  @override
  _Verification2PageState createState() => _Verification2PageState();
}

class _Verification2PageState extends State<Verification2Page> {
  Color _color1 = Color(0xFF3FB5E4);
  Color _color2 = Color(0xFF515151);
  Color _color3 = Color(0xff777777);
  Color _color4 = Color(0xFFaaaaaa);

  FirebaseAuth auth = FirebaseAuth.instance;
  bool _buttonDisabled = true;
  String _verificationCode = '';
  bool _ispress = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          padding: EdgeInsets.fromLTRB(30, 120, 30, 30),
          children: <Widget>[
            Center(
                child: Icon(Icons.phone_android, color: _color1, size: 50)),
            SizedBox(height: 20),
            Center(
                child: Text(
                  'إضافة الكود المرسل لك هنا',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _color2
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Text(
                'تم إرسالة كود خاص بك علي الرقم الذي تم إضافته لا تعطي هذا الرقم لأي شخص: '+ widget.phoneNumber,
                style: TextStyle(
                    fontSize: 13,
                    color: _color3
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: PinCodeTextField(
                  autoFocus: true,
                  appContext: context,
                  keyboardType: TextInputType.number,
                  length: 6,
                  showCursor: false,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(

                      shape: PinCodeFieldShape.underline,
                      fieldHeight: 50,
                      fieldWidth: 40,
                      inactiveColor: _color4,
                      activeColor: _color1,
                      selectedColor: _color1
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  onChanged: (value) {
                    setState(() {
                      if(value.length==6){
                        _buttonDisabled = false;
                      } else {
                        _buttonDisabled = true;
                      }
                      _verificationCode = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    return false;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              child: SizedBox(
                  width: double.maxFinite,
                  child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) => _buttonDisabled?Colors.grey[300]!:_color1,
                        ),
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            )
                        ),
                      ),
                      onPressed: widget.is_out ? null : () async {

                        FocusScope.of(context).unfocus();

                        if(_ispress){
                          //return;
                        }

                        setState(() {
                          _ispress = true;
                        });

                        if(!_buttonDisabled){
                          print(_verificationCode);

                          // Create a PhoneAuthCredential with the code
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.vId, smsCode: _verificationCode);
                          // Sign the user in (or link) with the credential
                          await auth.signInWithCredential(credential);

                          setState(() {
                            _ispress = false;
                          });

                          if(auth.currentUser != null){
                            if(widget.type == "signup"){
                              register();
                            }
                            if(widget.type == "forgot"){
                              forgetpassword();
                            }
                            return;
                          }


                          Fluttertoast.showToast(msg: "الكود المدخل غير صحيح", toastLength: Toast.LENGTH_LONG);





                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: _ispress ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )  : Text(
                          'التحقق من الرقم',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _buttonDisabled?Colors.grey[600]:Colors.white),
                          textAlign: TextAlign.center,
                        )  ,
                      )
                  )
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Wrap(
                children: [
                  Text(
                    "إذا لم يصلك الكود خلال دقيقه؟ ",
                    style: TextStyle(
                        fontSize: 13,
                        color: _color4
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text(
                      'رجوع',
                      style: TextStyle(
                          fontSize: 13,
                          color: _color1
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
    );
  }

  void register() async {

    Dio.Response res = await dio().post('/register', data: widget.creds);
    Map j = res.data;
    print(res.data);
    if(j['status'] == "error"){
      Fluttertoast.showToast(msg: j['error'], toastLength: Toast.LENGTH_LONG);
    }else if(j['status'] == "success"){
      Provider.of<Auth>(context, listen: false).tryToken(j['token']);
      Navigator.pop(context, "login");
    }else{
      Fluttertoast.showToast(msg: j['error'], toastLength: Toast.LENGTH_SHORT);
    }


  }

  void forgetpassword() async {

    Dio.Response res = await dio().post('/forgetpassword', data: widget.creds);
    Map j = res.data;
    print(res.data);
    if(j['status'] == "error"){
      Fluttertoast.showToast(msg: j['error'], toastLength: Toast.LENGTH_LONG);
    }else if(j['status'] == "success"){
      Provider.of<Auth>(context, listen: false).tryToken(j['token']);
      Navigator.pop(context, "login");
    }else{
      Fluttertoast.showToast(msg: j['error'], toastLength: Toast.LENGTH_SHORT);
    }


  }


}
