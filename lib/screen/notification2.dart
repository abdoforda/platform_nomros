import 'dart:async';

import 'package:platform_nomros/model/home_class.dart';
import 'package:platform_nomros/model/screen/notification2_model.dart';
import 'package:platform_nomros/ui/reusable/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Notification2Page extends StatefulWidget {

  List<Notificatios>? notificatios;
  Notification2Page(this.notificatios);



  @override
  _Notification2PageState createState() => _Notification2PageState();
}

class _Notification2PageState extends State<Notification2Page> {
  Color _color1 = Color(0xFF515151);
  Color _color2 = Color(0xff777777);

  final _shimmerLoading = ShimmerLoading();

  bool _loading = true;
  Timer? _timerDummy;

  void getData(){
    // this timer function is just for demo, so after 2 second, the shimmer loading will disappear and show the content
    _timerDummy = Timer(Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });

  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _timerDummy?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          title: Text(
            'الإشعارات',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black
            ),
          ),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
              child: Container(
                color: Colors.grey[100],
                height: 1.0,
              ),
              preferredSize: Size.fromHeight(1.0)),
        ),
        body: RefreshIndicator(
          onRefresh: refreshData,
          child: (_loading == true)
              ? _shimmerLoading.buildShimmerContent()
              : ListView(
              children: List.generate(widget.notificatios!.length, (index) {
                return _createItem(index);
              })
          ),
        )
    );
  }

  Future refreshData() async {
    setState(() {
      _loading = true;
      getData();
    });
  }

  Widget _createItem(int index){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //Fluttertoast.showToast(msg: 'Click Title '+_notificationData1[index].title, toastLength: Toast.LENGTH_SHORT);
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.notificatios![index].yearName.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _color1)),
                    SizedBox(
                      height: 4,
                    ),
                    Text(widget.notificatios![index].createdAt.toString(),
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 11)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(widget.notificatios![index].title.toString(), style: TextStyle(color: _color2)),
                  ],
                )),
            Divider(
              height: 1,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
