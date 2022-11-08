import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:platform_nomros/model/home_class.dart';
import 'package:platform_nomros/model/screen/product_model.dart';
import 'package:platform_nomros/screen/qrcode.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:platform_nomros/ui/reusable/global_function.dart';
import 'package:platform_nomros/ui/reusable/global_widget.dart';
import 'package:platform_nomros/ui/reusable/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pod_player/pod_player.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:like_button/like_button.dart';

import 'package:percent_indicator/percent_indicator.dart';

import '../services/dio.dart';

class Video extends StatefulWidget {
  Lectures l;
  Video(this.l);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {

  final storage = new FlutterSecureStorage();

  late int _count;
  // initialize global function and global widget
  final _globalFunction = GlobalFunction();
  final _globalWidget = GlobalWidget();
  final _shimmerLoading = ShimmerLoading();
  bool _loading = true;
  Timer? _timerDummy;
  bool _isButtonDisabled = false;
  var _qrCode = TextEditingController();
  bool _isBuying = false;

  Color _color1 = Color(0xFF515151);
  Color _color2 = Color(0xff777777);
  List<ProductModel> _productData = [];
  late String _urlVideo;
  late final PodPlayerController controller;

  @override
  void initState() {

    if(widget.l.key.toString().isEmpty){
        checkPuyed();
    }else{
      cp(widget.l.key.toString());
    }

    setState(() {
      _count = widget.l.likes!;
    });

    super.initState();
  }

  @override
  void dispose() {
    print("aaaaaaaaaaaaaaaaaaaaaaaaa");
    controller.dispose();
    print("aaaaaa Position dispose: " +
        controller.currentVideoPosition.toString());
    setDuration();
    _timerDummy?.cancel();
    super.dispose();
  }

  void setDuration() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('duration${widget.l.key.toString()}',
        controller.currentVideoPosition.toString());
  }

  void setSeekTo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String patientPhone =
        await prefs.getString('duration${widget.l.key.toString()}') ?? "00000";
    print("aaaaaa parseDuration: " + patientPhone);
    controller.videoSeekTo(parseDuration(patientPhone));
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return new Future.value(true);
        },
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              elevation: 0,
              title: Text(
                widget.l.title.toString(),
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                  child: Container(
                    color: Colors.grey[100],
                    height: 1.0,
                  ),
                  preferredSize: Size.fromHeight(1.0)),
              actions: [
                Container(
                  margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: LikeButton(
                    mainAxisAlignment: MainAxisAlignment.start,
                    size: 32,
                    isLiked: null,
                    circleColor: CircleColor(
                      start: Colors.red[200]!,
                      end: Colors.red[400]!,
                    ),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Colors.red[700]!,
                      dotSecondaryColor: Colors.red[200]!,
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red[700] : Colors.grey,
                        size: 32,
                      );
                    },
                    likeCount: _count,
                    countPostion: CountPostion.left,
                    countBuilder: (int? count, bool isLiked, String text) {

                      return Text(
                        text,
                        style: TextStyle(
                          color: isLiked ? Colors.grey : Colors.red,
                        ),
                      );
                    },
                    likeCountPadding: EdgeInsets.only(top: 4.0),
                    countDecoration: (Widget count, int? likeCount) {

                      likeU(likeCount);

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          count,
                          SizedBox(
                            width: 10.0,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                widget.l.isPaid!
                    ? Column(
                  textDirection: TextDirection.rtl,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: PodVideoPlayer(
                        controller: controller,
                        videoTitle: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomLeft: Radius.circular(6),
                              ),
                              color: Color(0x3bd5c07e)),
                          child: Text(
                            widget.l.title.toString(),
                            style: TextStyle(color: Color(0xffe2b52a)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      width: double.infinity,
                      child: Column(
                        children: [

                        Container(
                          width: double.infinity,
                          child: Text(widget.l.title.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Text("تاريخ الإضافة: ", style: TextStyle(fontSize: 12),),
                              Text(widget.l.ago.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                            ],
                          )
                        ),
                        ],
                      )
                    ),
                  ],
                )
                    : Column(
                        children: [
                          SizedBox(height: 28,),
                          Center(
                            child: Text(
                              "المحتوي مدفوع",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26),
                            ),
                          ),
                          Center(
                            child: Text(
                              "هذا المحتوي غير مجاني يجب إدخال كود الشراء او تصوير الباركود للتفعيل",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.all(16),
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.key_rounded),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text("لديك مفتاح لتشغيل الفيديو؟")
                                  ],
                                ),
                                SizedBox(height: 12,),
                                CupertinoTextField(
                                  controller: _qrCode,
                                  onChanged: (value) {
                                    if(value.isEmpty){
                                      setState(() {
                                        _isButtonDisabled = false;
                                      });
                                    }else{
                                      setState(() {
                                        _isButtonDisabled = true;
                                      });
                                    }
                                  },
                                  textCapitalization: TextCapitalization.characters,
                                  style: TextStyle(color: CupertinoColors.activeBlue ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color:  CupertinoDynamicColor.withBrightness(
                                      color: CupertinoColors.white,
                                      darkColor: CupertinoColors.white,
                                    )
                                  ),
                                  padding: EdgeInsets.all(12),
                                  textAlign: TextAlign.left,
                                  placeholder: 'QR Code',
                                  placeholderStyle: TextStyle(color: CupertinoColors.activeBlue),
                                ),
                                SizedBox(height: 12,),
                                CupertinoButton(
                                  child: Text('إفتح', style: TextStyle(fontFamily: 'arabic'),),
                                  color: CupertinoColors.activeBlue,
                                  onPressed: _isButtonDisabled ? (){
                                    sendCode();
                                  } : null,
                                ),
                                _isBuying ?
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  child: LinearPercentIndicator(
                                    lineHeight: 24.0,
                                    percent: 1.0,
                                    center: Text("جاري التحقق من الباركود", style: TextStyle(
                                        color: Colors.white
                                    )),
                                    backgroundColor: Colors.grey,
                                    progressColor: Colors.blue,
                                    animation: true,
                                    animationDuration: 4000,
                                    onAnimationEnd: (){

                                    },
                                  ),
                                ) :
                                SizedBox( height: 50, ),
                                Row(
                                  children: [
                                    Icon(Icons.album_outlined),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text("أو يمكنك إلتقاط الباركود من خلال الكاميرا")
                                  ],
                                ),
                                SizedBox( height: 8, ),
                                CupertinoButton(
                                  child: Text('إلتقاط الباركود QR', style: TextStyle(fontFamily: 'arabic', color: Colors.white),),
                                  color: CupertinoColors.activeBlue,
                                  onPressed: () async {
                                    var result = await Navigator.push(context, CupertinoPageRoute(builder: (context) => BarcodeScanner2Page()));
                                    print("aaaassdd ${result}");
                                    if(result != -1){
                                      _qrCode.text = result.toString();
                                      setState(() {
                                        FocusScope.of(context).unfocus();
                                        _isButtonDisabled = true;
                                      });
                                      sendCode();
                                    }

                                    },
                                ),
                                SizedBox( height: 50, ),
                                Text("يمكنك التواصل مع فريق الدعم وشراء كوبون لفتح المحتوي", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox( height: 12, ),
                                CupertinoButton(
                                  child: Text('التواصل مع فريق الدعم', style: TextStyle(fontFamily: 'arabic', color: Colors.white),),
                                  color: CupertinoColors.systemYellow,
                                  onPressed: (){ },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
              ],
            )));
  }

  sendCode() async {

    setState(() {
      _isBuying = true;
      _isButtonDisabled =false;
    });

    Map creds = {
      'code': _qrCode.text,
      'lecture_id': widget.l.id,
    };

    Dio.Response res = await dioAuth(context).post('/sendcode', data: creds);
    print(res.data);
    Map j = res.data;
    if(j['status'] == "error"){
      Fluttertoast.showToast(msg: j['error'], toastLength: Toast.LENGTH_LONG);
    }else if(j['status'] == "success"){
      Fluttertoast.showToast(msg: "تم فتح المحتوي لك بنجاح", toastLength: Toast.LENGTH_LONG);
      Lectures l2 = Lectures.fromJson(j['lecture']);
      widget.l = l2;

      String json = jsonEncode(j['lecture']);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('l2${widget.l.id.toString()}', json);

      setState(() {
        cp(l2.key.toString());
      });

    }else{
      Fluttertoast.showToast(msg: j['error'], toastLength: Toast.LENGTH_SHORT);
    }

    setState(() {
      _isBuying = false;
      _isButtonDisabled = true;
    });

  }

  void checkPuyed() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    final String patientPhone =
        await prefs.getString('l2${widget.l.id.toString()}') ?? "";

    print("aaaaaaa map0 ${patientPhone}");

    if(patientPhone == null){
      print("aaaaaaa patientPhone nullllllllllll");
    }else{
      Map<String, dynamic> g = jsonDecode(patientPhone);
      Lectures l3 = Lectures.fromJson(g);
      setState(() {
        widget.l = l3;
      });
      cp(l3.key.toString());
    }

  }

  void cp(String string) {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube(string),
      podPlayerConfig: const PodPlayerConfig(
        autoPlay: false,
        forcedVideoFocus: true,
      ),
    )..initialise();
    setSeekTo();
  }

  void likeU(int? likeCount) async {
    Dio.Response res = await dioAuth(context).get("/like_lecture?id="+widget.l.id.toString());
    print("aaaaaaaaaaaa ${res.data}");
  }




}
