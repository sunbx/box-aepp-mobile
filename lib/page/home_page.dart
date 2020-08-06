import 'dart:ui';

import 'package:box/dao/account_info_dao.dart';
import 'package:box/dao/base_data_dao.dart';
import 'package:box/dao/wallet_record_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/base_data_model.dart';
import 'package:box/model/wallet_record_model.dart';
import 'package:box/page/aens_page.dart';
import 'package:box/page/search_page.dart';
import 'package:box/page/settings_page.dart';
import 'package:box/page/token_receive_page.dart';
import 'package:box/page/token_send_one_page.dart';
import 'package:box/page/tx_detail_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/bottom_navigation_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/taurus_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';

import '../main.dart';
import 'aens_register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  var _top = 400.00;
  var token = "loading...";
  var page = 1;
  var loadingType = LoadingType.loading;

  WalletTransferRecordModel walletRecordModel;
  BaseDataModel baseDataModel;

  Animation<RelativeRect> _animation;
  AnimationController _controller;
  Animation _curve;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAnimation();
    netAccountInfo();
    netBaseData();
  }

  void initAnimation() {
    //动画控制器
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    //动画插值器
    _curve = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    //动画变化范围
    _animation = RelativeRectTween(begin: RelativeRect.fromLTRB(0.0, 380.0, 0.0, -300), end: RelativeRect.fromLTRB(0.0, 210.0, 0.0, -300)).animate(_curve);
    //启动动画
    //    _controller.forward();
  }

  void netAccountInfo() {
    AccountInfoDao.fetch().then((AccountInfoModel model) {
      if (model.code == 200) {
        print(model.data.balance);
        token = model.data.balance;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netWalletRecord() {

    WalletRecordDao.fetch(page).then((WalletTransferRecordModel model) {
      loadingType = LoadingType.finish;
      if (model.code == 200) {
        walletRecordModel = model;
        setState(() {});
      } else {}
    }).catchError((e) {
      loadingType = LoadingType.error;
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netBaseData() {

    BaseDataDao.fetch().then((BaseDataModel model) {
      if (model.code == 200) {
        baseDataModel = model;
//        setState(() {});
        netWalletRecord();
      } else {}
    }).catchError((e) {
      print(e.toString());
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
//    _top = 380.00;
//    netWalletRecord();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        child: Scaffold(
//          floatingActionButtonLocation: CustomFloatingActionButtonLocation(FloatingActionButtonLocation.endFloat, -20, -50),
          floatingActionButton: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              onTap: () {
//    Navigator.push(context, PageRouteBuilder(pageBuilder:(BuildContext context, Animation animation,Animation secondaryAnimation) { ScaleTransition(scale: animation,alignment: Alignment.bottomRight,child: SearchPage());
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
              },
              child: Container(
                child: Image(
                  width: 100,
                  height: 100,
                  image: AssetImage('images/home_search.png'),
                ),
              ),
            ),
          ),

          backgroundColor: Color(0xFFFC2764).withAlpha(220),
//            backgroundColor: Color(0xFFEEEEEE),
          body: Container(
            margin: EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
            child: EasyRefresh(
              onRefresh: _onRefresh,
              bottomBouncing: false,
              header: TaurusHeader(backgroundColor: Color(0xFFFC2365)),
              child: Container(
                height: MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Image(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        image: AssetImage('images/home_bg.png'),
                      ),
                    ),
                    Positioned(
                        top: 10,
                        left: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 18),
                                      alignment: Alignment.topLeft,
                                      child: Image(
                                        width: 153,
                                        height: 36,
                                        image: AssetImage('images/home_logo.png'),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                                      },
                                      child: Container(
                                        height: 55,
                                        width: 55,
                                        padding: EdgeInsets.all(15),
                                        child: Image(
                                          width: 36,
                                          height: 36,
                                          image: AssetImage('images/home_settings.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 3,
                                  ),
                                ],
                              ),
//                              Container(
////                  width: 414,
//                                  height: 160,
//                                  alignment: Alignment.centerLeft,
//                                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//                                  //边框设置
//                                  decoration: new BoxDecoration(
//                                      color: Color(0xFFFFFFFF),
//                                      //设置四周圆角 角度
//                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
//                                      boxShadow: [
//                                        BoxShadow(
//                                            color: Colors.black.withAlpha(30),
//                                            offset: Offset(0.0, 15.0), //阴影xy轴偏移量
//                                            blurRadius: 15.0, //阴影模糊程度
//                                            spreadRadius: 1.0 //阴影扩散程度
//                                            )
//                                      ]
//                                      //设置四周边框
//                                      ),
//                                  child: Container(
//                                    alignment: Alignment.center,
//                                    padding: const EdgeInsets.only(left: 20, right: 20),
//                                    child: Row(
////                                      crossAxisAlignment: CrossAxisAlignment.start,
//                                      children: <Widget>[
////                                        Container(
////                                          height: 76,
////
////                                          width: 76,
////                                          //边框设置
////                                          decoration: new BoxDecoration(
////                                            color: Colors.blue,
////                                            //设置四周圆角 角度
////                                            borderRadius: BorderRadius.all(Radius.circular(100)),
////                                            //设置四周边框
////                                          ),
////                                        ),
//
//                                        Container(
//                                          height: 120,
//                                          alignment: Alignment.centerLeft,
//                                          width: MediaQuery.of(context).size.width - 40 -40,
//                                          child: Column(
//                                            children: <Widget>[
//                                              Container(
//                                                margin: const EdgeInsets.only(left: 10, top: 5),
//                                                child: Row(
//                                                  children: <Widget>[
//                                                    Text(
//                                                      "我的资产 (AE)",
//                                                      style: TextStyle(fontSize: 16, color: Color(0xFF999999)),
//                                                    ),
//                                                    Text("")
//                                                  ],
//                                                ),
//                                              ),
//                                              Container(
//                                                margin: const EdgeInsets.only(left: 10, top: 4),
//                                                child: Row(
////                                              crossAxisAlignment: CrossAxisAlignment.end,
//                                                  children: <Widget>[
////                            buildTypewriterAnimatedTextKit(),
//                                                    Text(
//                                                      "610.92334",
//                                                      style: TextStyle(
//                                                        fontSize: 35,
//                                                        color: Color(0xff414C57),
////                                                        fontWeight: FontWeight.bold,
//                                                        letterSpacing: -1.0,
//                                                      ),
//                                                    ),
////
////                            Text(
////                              token,
////                              style: TextStyle(fontSize: 35, color: Colors.white),
////                            )
//                                                  ],
//                                                ),
//                                              ),
//                                              Container(
//                                                margin: const EdgeInsets.only(left: 10, top: 5),
//                                                child:  Text(
//                                                  "ak_ idk x6m 3bg Rr7 WiK XuB 8EB YBo RqV saS c6q o4d sd2 3HK gj3 qiC F",
//                                                  style: TextStyle(
//                                                    fontSize: 14,
//                                                    color: Color(0xFF999999),
//                                                  ),
//                                                ),
//                                              ),
//                                            ],
//                                          ),
//                                        ),
//
////                                      Column(
////                                        children: <Widget>[
////
////                                        ],
////                                      ),
//                                      ],
//                                    ),
//                                  )),
                              Container(
//                  width: 414,
                                height: 150,
                                alignment: Alignment.centerLeft,
//                                padding: const EdgeInsets.only(top: 10, left: 18, right: 18),

                                child: Column(
                                  children: <Widget>[
//                                    Container(
//                                      margin: const EdgeInsets.only(top: 0, left: 18),
//                                      child: Row(
//                                        children: <Widget>[
//                                          Text(
//                                            "",
//                                            style: TextStyle(fontSize: 13, color: Colors.white70),
//                                          ),
//                                          Text("")
//                                        ],
//                                      ),
//                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 35, left: 18),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),
                                          Container(
                                            child: Text(
                                              token,
                                              style: TextStyle(fontSize: 35, color: Colors.white),
                                            ),
                                            alignment: Alignment.center,
                                          ),

                                          Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: Text(
                                              "  AE",
                                              style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: "Ubuntu"),
                                            ),
                                          ),

//
//                            Text(
//                              token,
//                              style: TextStyle(fontSize: 35, color: Colors.white),
//                            )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(top: 18, left: 18, right: 18),
                                      child: Text(
                                        "ak_idkx6m3bgRr7WiKXuB8EBYBoRqVsaSc6qo4dsd23HKgj3qiCF",
                                        style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.3, letterSpacing: 1.0, fontFamily: "Ubuntu"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: 18, top: 20),
                                child: Text(
                                  "Function",
                                  style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "Ubuntu"),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                child: Row(
                                  children: <Widget>[
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => TokenSendOnePage()));
                                        },
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10, bottom: 10),
                                          width: (MediaQuery.of(context).size.width - 20) / 4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Image(
                                                  width: 65,
                                                  height: 65,
                                                  image: AssetImage('images/home_send.png'),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Send",
                                                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: "Ubuntu"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => TokenReceivePage()));
                                        },
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10, bottom: 10),
                                          width: (MediaQuery.of(context).size.width - 20) / 4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Image(
                                                  width: 65,
                                                  height: 65,
                                                  image: AssetImage('images/home_receive.png'),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Receive",
                                                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: "Ubuntu"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AensPage()));
                                        },
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10, bottom: 10),
                                          width: (MediaQuery.of(context).size.width - 20) / 4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Image(
                                                  width: 65,
                                                  height: 65,
                                                  image: AssetImage('images/home_aens.png'),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Names",
                                                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: "Ubuntu"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10, bottom: 10),
                                          width: (MediaQuery.of(context).size.width - 20) / 4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Image(
                                                  width: 65,
                                                  height: 65,
                                                  image: AssetImage('images/home_game.png'),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Games",
                                                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: "Ubuntu"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    PositionedTransition(
//                        top: _top,
                        rect: _animation,
                        child: GestureDetector(
                          onPanUpdate: (e) {
//                            setState(() {
//                              print("update");
//                              _top = _top + e.delta.dy;
//                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),

                            width: MediaQuery.of(context).size.width,

                            //边框设置
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              //设置四周圆角 角度
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                              //设置四周边框
                            ),

                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: 18, top: 20),
                                  child: Text(
                                    "Transaction",
                                    style: TextStyle(fontSize: 18, color: Color(0xFF000000)),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: 18, top: 15),
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                                  ),
                                  height: 23,
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                ),
                                NotificationListener<ScrollNotification>(
                                  // 添加 NotificationListener 作为父容器
                                  // ignore: missing_return
                                  onNotification: (scrollNotification) {
                                    ScrollMetrics metrics = scrollNotification.metrics;
                                    // 注册通知回调
                                    if (scrollNotification is ScrollStartNotification) {
                                      // 滚动开始
                                    } else if (scrollNotification is ScrollUpdateNotification) {
                                      // 滚动位置更新
                                      if (metrics.pixels > 0) {
                                        _controller.forward();
                                      } else {
                                        _controller.reverse();
                                      }
                                      print(_top);
                                      print(metrics.pixels);
                                      _top = metrics.pixels;

                                      return true;
                                    } else if (scrollNotification is ScrollEndNotification) {}

                                    return true;
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.only(top: 10, bottom: 80),
//                                      height: MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top - 50 - 100 - 400,
                                      height: getListWidgetHeight(context),
                                      child: LoadingWidget(
                                        type: loadingType,
                                        child: EasyRefresh(
//                                        scrollController: _scrollController,
                                          onLoad: _onLoad,
                                          header: MaterialHeader(valueColor: AlwaysStoppedAnimation(Color(0xFFFC2365))),
                                          child: ListView.builder(
                                            itemCount: walletRecordModel == null ? 0 : walletRecordModel.data.length,
                                            shrinkWrap: true,


//                                    physics: new NeverScrollableScrollPhysics(),
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Material(
                                                color: Colors.white,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => TxDetailPage()));
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 18, right: 18, bottom: 20, top: 10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          //边框设置
                                                          decoration: new BoxDecoration(
//                                                  color:Colors.green,
                                                              color: Color(0xFFFC2365),
                                                              //设置四周圆角 角度
                                                              borderRadius: BorderRadius.all(Radius.circular(30)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Color(0xFFFC2365).withAlpha(20),
                                                                    offset: Offset(0.0, 3.0), //阴影xy轴偏移量
                                                                    blurRadius: 5.0, //阴影模糊程度
                                                                    spreadRadius: 1.0 //阴影扩散程度
                                                                    )
                                                              ]
                                                              //设置四周边框
                                                              ),

                                                          child: Text(
                                                            (int.parse(baseDataModel.data.blockHeight) - walletRecordModel.data[index].blockHeight).toString(),
                                                            style: TextStyle(color: Colors.white, fontSize: 14),
                                                          ),
                                                          alignment: Alignment.center,
                                                          height: 23,
                                                          width: 65,
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(left: 18),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                width: MediaQuery.of(context).size.width - 65 - 18 - 40,
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Expanded(
                                                                      child: Container(
                                                                        child: Text(
                                                                          walletRecordModel.data[index].tx.type,
                                                                          style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: "Ubuntu"),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: getFeeWidget(index),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(top: 8),
                                                                child: Text(
                                                                  walletRecordModel.data[index].hash,
                                                                  strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: "Ubuntu"),
                                                                  style: TextStyle(
                                                                    color: Colors.black.withAlpha(80),
                                                                    letterSpacing: 1.0,
                                                                    fontSize: 13,
                                                                  ),
                                                                ),
                                                                width: 250,
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(top: 6),
                                                                child: Text(
                                                                  DateTime.fromMicrosecondsSinceEpoch(walletRecordModel.data[index].time * 1000).toLocal().toString(),
                                                                  style: TextStyle(color: Colors.black.withAlpha(80), fontSize: 13, letterSpacing: 1.0, fontFamily: "Ubuntu"),
                                                                ),
                                                              ),
                                                            ],
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(""),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onLoad() async {
    await Future.delayed(Duration(seconds: 1), () {
      page++;
      netWalletRecord();
    });
  }

  Future<void> _onRefresh() async {
    page =1;
    if (page == 1) {
      loadingType = LoadingType.loading;
    }
    setState(() {

    });
    await Future.delayed(Duration(seconds: 1), () {

     netAccountInfo();
     netBaseData();
    });
  }



  double getListWidgetHeight(BuildContext context) {
    if (loadingType != LoadingType.loading) {
      return MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top - 50 - 100 - 100;
    } else {
      return MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top - 50 - 100 - 400;
    }
  }

  Text getFeeWidget(int index) {
    if (walletRecordModel.data[index].tx.type == "SpendTx") {
      if (walletRecordModel.data[index].tx.recipientId == BoxApp.getAddress()) {
        return Text(
          "+" + (walletRecordModel.data[index].tx.amount.toDouble() / 1000000000000000000).toString()+" AE",
          style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: "Ubuntu"),
        );
      } else {
        return Text(
          "-" + (walletRecordModel.data[index].tx.amount.toDouble() / 1000000000000000000).toString()+" AE",
          style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: "Ubuntu"),
        );
      }
    } else {
      return Text(
        "-" + (walletRecordModel.data[index].tx.fee.toDouble() / 1000000000000000000).toString()+" AE",
        style: TextStyle(color: Colors.black.withAlpha(80), fontSize: 14, fontFamily: "Ubuntu"),
      );
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
