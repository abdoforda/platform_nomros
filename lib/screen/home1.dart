import 'dart:async';


import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:platform_nomros/config/constant.dart';
import 'package:platform_nomros/model/feature/banner_slider_model.dart';
import 'package:platform_nomros/screen/notification2.dart';

import 'package:platform_nomros/screen/teachers.dart';
import 'package:platform_nomros/screen/update.dart';
import 'package:platform_nomros/screen/user_profile2.dart';
import 'package:platform_nomros/screen/video.dart';
import 'package:platform_nomros/services/auth.dart';
import 'package:platform_nomros/ui/reusable/cache_image_network.dart';
import 'package:platform_nomros/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../model/home_class.dart';
import '../services/dio.dart';
import '../ui/reusable/shimmer_loading.dart';

class Home1Page extends StatefulWidget {
  @override
  _Home1PageState createState() => _Home1PageState();
}

class _Home1PageState extends State<Home1Page> {
  // initialize global widget
  final _globalWidget = GlobalWidget();
  final _shimmerLoading = ShimmerLoading();
  late Home _home;

  double _spaceHeight = 10;
  Color _shimmerColor = Colors.grey[200]!;

  Color _colorHome = Color(0xFFf3f4f6);
  Color _color1 = Color(0xFF3176ef);
  Color _color2 = Color(0xFF37474f);

  bool _loading = true;
  Timer? _timerDummy;

  int _currentImageSlider = 0;

  List<BannerSliderModel> _movieData = [];

  late String name2;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() async {
      Dio.Response response = await dioAuth(context).get('/home');
    print(response.data);
    _home = Home.fromJson(response.data);
    if(_home.v.toString() != "1.0.0"){
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
        builder: (context) => UpdateApp()), (route) => false);
      return;
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bannerWidth = MediaQuery.of(context).size.width;
    double bannerHeight = MediaQuery.of(context).size.width / 2;
    double bannerHeight2 = MediaQuery.of(context).size.width / 4;
    final double boxImageSize = (MediaQuery.of(context).size.width / 3);

    return Scaffold(
      backgroundColor: _colorHome,
      appBar: AppBar(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Image.asset('assets/images/logo_horizontal.png',
              height: 24),
          backgroundColor: _color1,
          leading: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => UserProfile2Page(_home)));
              }),
          actions: <Widget>[
            IconButton(
                icon: _globalWidget.customNotifIcon(
                    count: _loading ? 0 : _home.notificatios!.length, notifColor: Colors.white),
                onPressed: () {
                  if(_home.notificatios != null){
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => Notification2Page(_home.notificatios)));
                  }

                }),
          ]),
      body: RefreshIndicator(
          onRefresh: refreshData,
          child: (_loading == true)
              ? ListView(
                  children: [
                    buildShimmerBanner(bannerWidth, bannerHeight2),
                    buildShimmerBanner(bannerWidth, bannerHeight),
                    buildShimmerCategory(),
                    Container(
                        height: boxImageSize,
                        child: buildShimmerImageHorizontal(boxImageSize))
                  ],
                )
              : ListView(
                  children: [
                    _buildTop(),
                    _buildHomeBanner(),
                    _createMenu(),
                    _comingSoon(),
                    _HelpMe(),
                  ],
                )),
    );
  }

  Widget _buildTop() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => UserProfile2Page(_home)));
            },
            child: Hero(
              tag: 'profilePicture',
              child: ClipOval(
                child: buildCacheNetworkImage(
                    url: urlImage + '/users/user.png',
                    width: 50),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => UserProfile2Page(_home)));
                    },
                    child: Text(
                      _home.user!.name.toString(),
                      style: TextStyle(
                          color: _color2,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      return;
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 6),
                        padding:
                            EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: _color2, size: 12),
                              SizedBox(width: 4),
                              Text(_home.user!.year!.name.toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: _color2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9))
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32),
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          GestureDetector(
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              FirebaseAuth.instance.signOut();
            },
            child: Text('خروج',
                style: TextStyle(color: _color2, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildHomeBanner() {
    return Stack(
      children: [
        CarouselSlider(
          items: _home.slidshow!
              .map((item) => Container(
                    child: GestureDetector(
                        onTap: () {
                          if(item.lecture != null){
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => Video(item.lecture!)));
                          }
                        },
                        child: buildCacheNetworkImage(
                            width: 0,
                            height: 0,
                            url: urlImage + item.image.toString())),
                  ))
              .toList(),
          options: CarouselOptions(
              aspectRatio: 2,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 6),
              autoPlayAnimationDuration: Duration(milliseconds: 300),
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentImageSlider = index;
                });
              }),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _home.slidshow!.map((item) {
              int index = _home.slidshow!.indexOf(item);
              return AnimatedContainer(
                duration: Duration(milliseconds: 150),
                width: _currentImageSlider == index ? 10 : 5,
                height: _currentImageSlider == index ? 10 : 5,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _createMenu() {
    return Column(
      children: [
        SizedBox(height: 14),
        Container(
          child: Text("المواد التعليمية",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
        ),
        Container(
          child: GridView.count(
            childAspectRatio: 1.1,
            shrinkWrap: true,
            primary: false,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            crossAxisCount: 3,
            children:
                List.generate(_home.user!.year!.materials!.length, (index) {
              return GestureDetector(
                  onTap: () {
                    // Fluttertoast.showToast(msg: 'Click '+_categoryData[index].name.replaceAll('\n', ' '), toastLength: Toast.LENGTH_SHORT);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => TeachersList(_home.user!.year!.materials![index])));
                  },
                  child: Container(
                    padding: EdgeInsets.all(1),
                    child: Card(
                      elevation: 1,
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            buildCacheNetworkImage(
                                width: 50,
                                height: 50,
                                url: urlImage +
                                    _home.user!.year!.materials![index].image
                                        .toString(),
                                plColor: Colors.transparent),
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              child: Text(
                                _home.user!.year!.materials![index].name
                                    .toString(),
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: _color2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ])),
                    ),
                  ));
            }),
          ),
        )
      ],
    );
  }

  Widget _comingSoon() {
    double boxSize = MediaQuery.of(context).size.width / 2.4;
    return Column(
      children: List.generate(_home.comingsoon!.length, (index) {
        return Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_home.comingsoon![index].name.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: 'Click view all',
                          toastLength: Toast.LENGTH_SHORT);
                    },
                    child: Text('مشاهدة الكل',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        )),
                  )
                ],
              ),
            ),
            Container(
              height: 170,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: _home.comingsoon![index].lectures!.length,
                itemBuilder: (BuildContext context, int x) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    width: boxSize,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => Video(_home.comingsoon![index].lectures![x])));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: buildCacheNetworkImage(
                                  width: boxSize,
                                  height: 100,
                                  url: urlImage+_home.comingsoon![index].lectures![x].image.toString())),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                    child: Text(
                                      _home.comingsoon![index].lectures![x].title.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    color: Color(0x41FFBF48),
                                    padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                    child: Text(
                                      _home.comingsoon![index].lectures![x].cat.toString(),
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w200,
                                          color: Colors.amber[700]),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _HelpMe() {
    double boxSize = MediaQuery.of(context).size.width / 2.4;
    return GestureDetector(
      onTap: () async {
        final link = WhatsAppUnilink(
          phoneNumber: _home.whatsapp.toString(),
          text: "مرحبا. التواصل بخصوص المنصة",
        );
        if(_home.whatsapp.toString().isEmpty){
          Fluttertoast.showToast(
              msg: 'سيتم فتح التواصل قريبا', toastLength: Toast.LENGTH_SHORT);
        }else{
          await launch('$link');
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("معاك هنسهل الصعب", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            Text("إضغط هنا للدعم او للإستفسار", style: TextStyle(color: Colors.white),),
            SizedBox(height: 10,),
            Image.asset("assets/images/help.png")
          ],
        ),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF3176ef), Color(0xFF1f48c8)]),
          borderRadius: BorderRadius.circular(8)
        ),
      ),
    );
  }

  Widget buildShimmerBanner(bannerWidth, bannerHeight) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Shimmer.fromColors(
        highlightColor: Colors.white,
        baseColor: _shimmerColor,
        child: Container(
          child: Container(
            width: bannerWidth,
            height: bannerHeight,
            color: _shimmerColor,
          ),
        ),
        period: Duration(milliseconds: 1000),
      ),
    );
  }

  Widget buildShimmerCategory() {
    return GridView.count(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      primary: false,
      childAspectRatio: 1.1,
      shrinkWrap: true,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      crossAxisCount: 4,
      children: List.generate(8, (index) {
        return Shimmer.fromColors(
          highlightColor: Colors.white,
          baseColor: _shimmerColor,
          period: Duration(milliseconds: 1000),
          child: Column(children: [
            Container(
              width: 40,
              height: 40,
              color: _shimmerColor,
            ),
            SizedBox(
              height: _spaceHeight,
            ),
            Container(
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: _shimmerColor,
              ),
              height: 12,
            ),
          ]),
        );
      }),
    );
  }

  Widget buildShimmerImageHorizontal(boxImageSize) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: 8,
      padding: EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(left: index == 0 ? 0 : 12),
          child: Shimmer.fromColors(
            highlightColor: Colors.white,
            baseColor: _shimmerColor,
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                child: Container(
                  width: boxImageSize,
                  height: boxImageSize,
                  color: _shimmerColor,
                ),
              ),
            ),
            period: Duration(milliseconds: 1000),
          ),
        );
      },
    );
  }

  Future refreshData() async {
    setState(() {
      _loading = true;
      _getData();
    });
  }
}
