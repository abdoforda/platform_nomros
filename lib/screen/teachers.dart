import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:platform_nomros/config/constant.dart';
import 'package:platform_nomros/model/home_class.dart';
import 'package:platform_nomros/model/screen/product_model.dart';
import 'package:platform_nomros/screen/lessons.dart';
import 'package:platform_nomros/ui/reusable/cache_image_network.dart';
import 'package:platform_nomros/ui/reusable/global_function.dart';
import 'package:platform_nomros/ui/reusable/global_widget.dart';
import 'package:platform_nomros/ui/reusable/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeachersList extends StatefulWidget {
  final Materials materials;
  TeachersList(this.materials);

  @override
  _TeachersListState createState() => _TeachersListState();
}

class _TeachersListState extends State<TeachersList> {
  // initialize global function and global widget
  final _globalFunction = GlobalFunction();
  final _globalWidget = GlobalWidget();
  final _shimmerLoading = ShimmerLoading();

  bool _loading = true;
  Timer? _timerDummy;

  Color _color1 = Color(0xFF515151);
  Color _color2 = Color(0xff777777);


  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    _timerDummy?.cancel();
    super.dispose();
  }

  void _getData() {
    // this timer function is just for demo, so after 2 second, the shimmer loading will disappear and show the content
    _timerDummy = Timer(Duration(seconds: 1), () {
      setState(() {
        _loading = false;
      });
    });
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
            "مادة "+widget.materials.name.toString(),
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
            IconButton(
                icon: Icon(Icons.search, color: _color2),
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: 'Click search', toastLength: Toast.LENGTH_SHORT);
                }),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: refreshData,
          child: (_loading == true)
              ? _shimmerLoading.buildShimmerProduct(
                  ((MediaQuery.of(context).size.width) - 24) / 2 - 12)
              : CustomScrollView(slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.500,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return _buildItem(index, widget.materials.teachers![index]);
                        },
                        childCount: widget.materials.teachers!.length,
                      ),
                    ),
                  ),
                ]),
        ));
  }

  Widget _buildItem(index, Teachers teacher) {
    final double boxImageSize =
        ((MediaQuery.of(context).size.width) - 24) / 2 - 12;
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        color: Colors.white,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => Lessons(teacher)));
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: buildCacheNetworkImage(
                        width: boxImageSize,
                        height: 220,
                        url: urlImage + teacher.image.toString())),
                Container(
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.name.toString(),
                        style: TextStyle(fontSize: 12, color: _color1),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(teacher.countVideos.toString()+' فيديوهات',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                            Text(teacher.countReviews.toString()+' مراجعات',
                                style: TextStyle(fontSize: 11, color: SOFT_GREY))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: SOFT_GREY, size: 12),
                            Text('سنتر مكة',
                                style: TextStyle(fontSize: 11, color: SOFT_GREY))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            _globalWidget.createRatingBar(
                                rating: 5, size: 12),
                            Text(
                                '(5)',
                                style: TextStyle(fontSize: 11, color: SOFT_GREY))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future refreshData() async {
    setState(() {
      _loading = true;
      _getData();
    });
  }
}
