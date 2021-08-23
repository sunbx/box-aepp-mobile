import 'dart:ui';

import 'package:box/dao/account_info_dao.dart';
import 'package:box/dao/block_top_dao.dart';
import 'package:box/dao/contract_balance_dao.dart';
import 'package:box/dao/contract_info_dao.dart';
import 'package:box/dao/name_reverse_dao.dart';
import 'package:box/dao/price_model.dart';
import 'package:box/dao/swap_dao.dart';
import 'package:box/dao/wallet_record_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/manager/wallet_coins_manager.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/contract_info_model.dart';
import 'package:box/model/name_reverse_model.dart';
import 'package:box/model/price_model.dart';
import 'package:box/model/swap_model.dart';
import 'package:box/model/wallet_coins_model.dart';
import 'package:box/model/wallet_record_model.dart';
import 'package:box/page/aeternity/ae_records_page.dart';
import 'package:box/page/aeternity/ae_token_defi_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/box_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../main.dart';

class CfxHomePage extends StatefulWidget {
  static var token = "0.00000";
  static var tokenABC = "0.00000";
  static var height = 0;
  static var address = "";

  @override
  _CfxHomePageState createState() => _CfxHomePageState();
}

class _CfxHomePageState extends State<CfxHomePage> with AutomaticKeepAliveClientMixin {
  PriceModel priceModel;
  var page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    eventBus.on<LanguageEvent>().listen((event) {
      netBaseData();
      getAddress();
    });
    eventBus.on<AccountUpdateEvent>().listen((event) {
      if (!mounted)
        return;
      priceModel = null;
      CfxHomePage.token = "0.00000";
      CfxHomePage.tokenABC = "0.00000";
      setState(() {});
      netBaseData();
      getAddress();
    });
    netBaseData();
    getAddress();
  }



  getAddress() {
    WalletCoinsManager.instance.getCurrentAccount().then((Account account) {
      CfxHomePage.address = account.address;
      setState(() {});
    });
  }

  void netBaseData() {
    var type = "usd";
    if (BoxApp.language == "cn") {
      type = "cny";
    } else {
      type = "usd";
    }
    PriceDao.fetch(type).then((PriceModel model) {
      priceModel = model;
      setState(() {});
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  String getAePrice() {
    if (CfxHomePage.token == "loading...") {
      return "";
    }
    if (BoxApp.language == "cn" && priceModel.aeternity != null) {
      if (priceModel.aeternity.cny == null) {
        return "";
      }
      if (double.parse(CfxHomePage.token) < 1000) {
        return "¥" + (priceModel.aeternity.cny * double.parse(CfxHomePage.token)).toStringAsFixed(4) + " ≈";
      } else {
//        return "≈ " + (2000.00*6.5 * double.parse(HomePage.token)).toStringAsFixed(0) + " (CNY)";
        return "¥" + (priceModel.aeternity.cny * double.parse(CfxHomePage.token)).toStringAsFixed(4) + " ≈";
      }
    } else {
      if (priceModel.aeternity.usd == null) {
        return "";
      }
      return "\$" + (priceModel.aeternity.usd * double.parse(CfxHomePage.token)).toStringAsFixed(4) + " ≈";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: EasyRefresh(
      header: BoxHeader(),
      onRefresh: _onRefresh,
      child: Container(
        child: Column(
          children: [
            // Container(
            //   height: 8,
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
//                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        boxShadow: [
//                                BoxShadow(
//                                    color: Color(0xFF000000).withAlpha(20),
//                                    offset: Offset(0.0, 55.0), //阴影xy轴偏移量
//                                    blurRadius: 50.0, //阴影模糊程度
//                                    spreadRadius: 0.1 //阴影扩散程度
//                                    )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            margin: const EdgeInsets.only(left: 16, right: 16),
                            decoration: new BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF37A1DB).withAlpha(20),
                                    offset: Offset(0.0, 55.0),
                                    //阴影xy轴偏移量
                                    blurRadius: 50.0,
                                    //阴影模糊程度
                                    spreadRadius: 0.1 //阴影扩散程度
                                    )
                              ],
                            ),
                          ),
//                          Container(
//                            height: 90,
//                            margin: const EdgeInsets.only(left: 16, right: 16),
//                            decoration: new BoxDecoration(
//                              boxShadow: [
//                                BoxShadow(
//                                    color: Color(0xFF3C5DE3).withAlpha(20),
//                                    offset: Offset(0.0, 55.0), //阴影xy轴偏移量
//                                    blurRadius: 50.0, //阴影模糊程度
//                                    spreadRadius: 0.1 //阴影扩散程度
//                                    )
//                              ],
//                            ),
//                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 160,
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  gradient: const LinearGradient(begin: Alignment.centerLeft, colors: [
                                    Color(0xFF3292C7),
                                    Color(0xFF37A1DB),

                                  ]),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 32,
                                  height: 35,
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                                    color: Color(0xFF3F7FB5),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 3,
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 32,
                                  height: 40,
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(top: 12, left: 15),
                                          child: Row(
                                            children: <Widget>[
                                              priceModel == null
                                                  ? Container()
                                                  : Container(
                                                      margin: const EdgeInsets.only(bottom: 5, left: 2, top: 2),
                                                      child: Text(
//                                                    "≈ " + (double.parse("2000") * double.parse(HomePage.token)).toStringAsFixed(2)+" USDT",
                                                        getAePrice(),
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(fontSize: 14, color: Colors.white, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                                      ),
                                                    ),

//                            buildTypewriterAnimatedTextKit(),

//                                                Container(
//                                                  width: 36.0,
//                                                  height: 36.0,
//                                                  decoration: BoxDecoration(
//                                                    border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
////                                                      shape: BoxShape.rectangle,
//                                                    borderRadius: BorderRadius.circular(36.0),
//                                                    image: DecorationImage(
//                                                      image: AssetImage("images/logo.png"),
////                                                        image: AssetImage("images/apple-touch-icon.png"),
//                                                    ),
//                                                  ),
//                                                ),
//                                                Container(
//                                                  padding: const EdgeInsets.only(left: 8, right: 18),
//                                                  child: Text(
//                                                    "ABC",
//                                                    style: new TextStyle(
//                                                      fontSize: 20,
//                                                      color: Colors.white,
////                                            fontWeight: FontWeight.w600,
//                                                      fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                                                    ),
//                                                  ),
//                                                ),
                                              Expanded(child: Container()),
                                              Text(
                                                CfxHomePage.tokenABC == "loading..."
                                                    ? "loading..."
                                                    : double.parse(CfxHomePage.tokenABC) > 1000
                                                        ? double.parse(CfxHomePage.tokenABC).toStringAsFixed(2) + " ABC"
                                                        : double.parse(CfxHomePage.tokenABC).toStringAsFixed(2) + " ABC",
//                                      "9999999.00000",
                                                overflow: TextOverflow.ellipsis,

                                                style: TextStyle(fontSize: 14, color: Colors.white, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                              ),
                                              Container(
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: CfxHomePage.address));
                                  Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 160,
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: 20, right: 50),
                                  child: Text(Utils.formatHomeCardAddressCFX(CfxHomePage.address), style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Color(0xffffffff).withAlpha(120), letterSpacing: 1.3, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu")),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 87,
                                  height: 58,
                                  child: Image(
                                    image: AssetImage("images/card_top.png"),
                                  ),
                                ),
                              ),
//                              Positioned(
//                                left: 60,
//                                bottom: 20,
//                                child: Container(
//                                  width: 15,
//                                  height: 15,
//                                  child: Image(
//                                    color: Colors.white.withAlpha(60),
//                                    image: AssetImage("images/index_bg4.png"),
//                                  ),
//                                ),
//                              ),
//                              Positioned(
//                                right: (MediaQuery.of(context).size.width - 32) / 3,
//                                top: 23,
//                                child: Container(
//                                  width: 25,
//                                  height: 25,
//                                  child: Image(
//                                    color: Colors.white.withAlpha(60),
//                                    image: AssetImage("images/index_bg2.png"),
//                                  ),
//                                ),
//                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 120,
                                  height: 46,
                                  child: Image(
                                    image: AssetImage("images/card_bottom.png"),
                                  ),
                                ),
                              ),

                              Container(
                                height: 130,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(top: 20, left: 18),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            S.of(context).home_page_my_count + " (AE）",
                                            style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                          ),
                                          Expanded(child: Container()),
                                          Container(
                                            margin: const EdgeInsets.only(left: 2, right: 20),
                                            child: Text(
                                              "",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 13, color: Colors.white70, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 20, left: 15),
                                      child: Row(
                                        children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),
//                                          Container(
//                                            width: 36.0,
//                                            height: 36.0,
//                                            decoration: BoxDecoration(
//                                              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), left: BorderSide(color: Color(0xFFEEEEEE), width: 1.0), right: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
////                                                      shape: BoxShape.rectangle,
//                                              borderRadius: BorderRadius.circular(36.0),
//                                              image: DecorationImage(
//                                                image: AssetImage("images/apple-touch-icon.png"),
////                                                        image: AssetImage("images/apple-touch-icon.png"),
//                                              ),
//                                            ),
//                                          ),
//                                          Container(
//                                            padding: const EdgeInsets.only(left: 8, right: 18),
//                                            child: Text(
//                                              "AE",
//                                              style: new TextStyle(
//                                                fontSize: 20,
//                                                color: Colors.white,
////                                            fontWeight: FontWeight.w600,
//                                                fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
//                                              ),
//                                            ),
//                                          ),
                                          Expanded(child: Container()),

                                          Row(
                                            children: [
//                                              priceModel == null
//                                                  ? Container()
//                                                  : Container(
//                                                margin: const EdgeInsets.only(bottom: 5, left: 2, top: 2),
//                                                child: Text(
////                                                    "≈ " + (double.parse("2000") * double.parse(HomePage.token)).toStringAsFixed(2)+" USDT",
//                                                  getAePrice(),
//                                                  overflow: TextOverflow.ellipsis,
//                                                  style: TextStyle(fontSize: 12, color: Colors.white, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
//                                                ),
//                                              ),

                                              Text(
                                                CfxHomePage.token == "loading..."
                                                    ? "loading..."
                                                    : double.parse(CfxHomePage.token) > 1000
                                                        ? double.parse(CfxHomePage.token).toStringAsFixed(2) + ""
                                                        : double.parse(CfxHomePage.token).toStringAsFixed(5) + "",
//                                      "9999999.00000",
                                                overflow: TextOverflow.ellipsis,

                                                style: TextStyle(fontSize: 38, color: Colors.white, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                                              ),
                                            ],
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                          ),
                                          Container(
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                    ),

//                                    Container(
//                                      alignment: Alignment.topLeft,
//                                      margin: const EdgeInsets.only(top: 8, left: 15, right: 15),
//                                      child: Text(
//                                        HomePageV2.address,
//                                        strutStyle: StrutStyle(forceStrutHeight: true, height: 0.5, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
//                                        style: TextStyle(fontSize: 13, letterSpacing: 1.0, color: Colors.white70, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 1.3),
//                                      ),
//                                    ),
                                  ],
                                ),
                              ),
//                              Positioned(
//                                right: 0,
//                                top: 0,
//                                child: GestureDetector(
//                                  onTap: (){
//                                    Clipboard.setData(ClipboardData(text: namesModel[0].name));
//                                    Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
//
//                                  },
//                                  child: Material(
//                                    color: Colors.transparent,
//                                    child: Container(
//                                      width: 80,
//                                      height: 80,
//
//                                    ),
//                                  ),
//                                ),
//                              ),
                            ],
                          ),
                          Container(
                            height: 48,
                            margin: EdgeInsets.only(left: 5, right: 0, top: 0, bottom: 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              S.of(context).home_send_receive,
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                fontFamily: BoxApp.language == "cn"
                                    ? "Ubuntu"
                                    : BoxApp.language == "cn"
                                        ? "Ubuntu"
                                        : "Ubuntu",
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 90,
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 0),
                                  //边框设置
                                  decoration: new BoxDecoration(
                                    color: Color(0xE6FFFFFF),
                                    //设置四周圆角 角度
                                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  child: Material(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    color: Colors.white,
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      onTap: () {
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => AeTokenSendOnePage()));
                                      },
                                      child: Container(
                                        height: 90,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.only(left: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 10),
                                                    child: Image(
                                                      width: 56,
                                                      height: 56,
                                                      image: AssetImage("images/home_send_token.png"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets.only(left: 5),
                                                      child: Text(
                                                        S.of(context).home_page_function_send,
                                                        style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
//                                            Positioned(
//                                              right: 23,
//                                              child: Container(
//                                                width: 25,
//                                                height: 25,
//                                                padding: const EdgeInsets.only(left: 0),
//                                                //边框设置
//                                                decoration: new BoxDecoration(
//                                                  color: Color(0xFFF5F5F5),
//                                                  //设置四周圆角 角度
//                                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                                                ),
//                                                child: Icon(
//                                                  Icons.arrow_forward_ios,
//                                                  size: 15,
//                                                  color: Color(0xFFCCCCCC),
//                                                ),
//                                              ),
//                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 12,
                              ),
                              Expanded(
                                child: Container(
                                  height: 90,
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 0),
                                  //边框设置
                                  decoration: new BoxDecoration(
                                    color: Color(0xE6FFFFFF),
                                    //设置四周圆角 角度
                                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  child: Material(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    color: Colors.white,
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      onTap: () {
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => TokenReceivePage()));
                                      },
                                      child: Container(
                                        height: 90,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.only(left: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 10),
                                                    child: Image(
                                                      width: 56,
                                                      height: 56,
                                                      image: AssetImage("images/home_receive_token.png"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets.only(left: 5),
                                                      child: Text(
                                                        S.of(context).home_page_function_receive,
                                                        style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
//                                            Positioned(
//                                              right: 23,
//                                              child: Container(
//                                                width: 25,
//                                                height: 25,
//                                                padding: const EdgeInsets.only(left: 0),
//                                                //边框设置
//                                                decoration: new BoxDecoration(
//                                                  color: Color(0xFFF5F5F5),
//                                                  //设置四周圆角 角度
//                                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                                                ),
//                                                child: Icon(
//                                                  Icons.arrow_forward_ios,
//                                                  size: 15,
//                                                  color: Color(0xFFCCCCCC),
//                                                ),
//                                              ),
//                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 90,
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 12),
                            //边框设置
                            decoration: new BoxDecoration(
                              color: Color(0xE6FFFFFF),
                              //设置四周圆角 角度
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Material(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: Colors.white,
                              child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AeTokenListPage()));
                                },
                                child: Container(
                                  height: 90,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(top: 10),
                                              child: Image(
                                                width: 56,
                                                height: 56,
                                                image: AssetImage("images/home_token.png"),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Text(
                                                  S.of(context).home_token,
                                                  style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        right: 23,
                                        child: Container(
                                          width: 25,
                                          height: 25,
                                          padding: const EdgeInsets.only(left: 0),
                                          //边框设置
                                          decoration: new BoxDecoration(
                                            color: Color(0xFFF5F5F5),
                                            //设置四周圆角 角度
                                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 15,
                                            color: Color(0xFFCCCCCC),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          getRecordContainer(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 8,
            ),
          ],
        ),
      ),
    ));
  }

  Container getRecordContainer(BuildContext context) {
//    if (walletRecordModel == null) {
//      return Container(
//        width: MediaQuery.of(context).size.width,
//        height: 50,
//      );
//    }
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 12, bottom: MediaQuery.of(context).padding.bottom),
      //边框设置
      decoration: new BoxDecoration(
        color: Color(0xE6FFFFFF),
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          splashColor: Colors.white,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AeRecordsPage()));
          },
          child: Column(
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Image(
                              width: 56,
                              height: 56,
                              image: AssetImage("images/home_record.png"),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              S.of(context).home_page_transaction,
                              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 23,
                      child: Container(
                        width: 25,
                        height: 25,
                        margin: const EdgeInsets.only(top: 23),
                        padding: const EdgeInsets.only(left: 0),
                        //边框设置
                        decoration: new BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if ("" != null)
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 15, top: 0),
                  child: Text(
                    S.of(context).home_page_transaction_conform,
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                  ),
                  height: 23,
                ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    // if (null == null)
                    //   Container(
                    //     height: 150,
                    //     child: new Center(
                    //       child: new CircularProgressIndicator(
                    //         valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFFF22B79)),
                    //       ),
                    //     ),
                    //   ),
                    if ("null"!= null && null == null)
                      Container(
                          child: Center(
                              child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              width: 198,
                              height: 164,
                              image: AssetImage('images/no_record.png'),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                S.of(context).home_no_record,
                                style: TextStyle(fontSize: 15, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xFF000000)),
                              ),
                            ),
                          ],
                        ),
                      ))),
                    getItem(context, 0),
                    getItem(context, 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container getTokensContainer(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 12),
      //边框设置
      decoration: new BoxDecoration(
        color: Color(0xE6FFFFFF),
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AeRecordsPage()));
          },
          child: Column(
            children: [
              Container(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Image(
                              width: 56,
                              height: 56,
                              image: AssetImage("images/home_financial.png"),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              "AEX9 Tokens",
                              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 23,
                      child: Container(
                        width: 25,
                        height: 25,
                        margin: const EdgeInsets.only(top: 23),
                        padding: const EdgeInsets.only(left: 0),
                        //边框设置
                        decoration: new BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    getTokensItem(context, 0),
                    getTokensItem(context, 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTokensItem(BuildContext context, int index) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => AeTxDetailPage(recordData: walletRecordModel.data[index])));
        },
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 18, top: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 75,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                "USDT",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "100000000.00",
                              style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                            ),
                          ),
                        ],
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
  }

  Widget getItem(BuildContext context, int index) {
    return Container();
    // if (walletRecordModel == null || walletRecordModel.data.length <= index) {
    //   return Container();
    // }
    if (index == 0) {}

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => AeTxDetailPage(recordData: walletRecordModel.data[index])));
        },
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 10, bottom: 20, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //边框设置

                child: Text(
                  "",
                  style: TextStyle(color: Color(0xFF000000), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                ),
                alignment: Alignment.center,
                height: 23,
                width: 40,
              ),
              Container(
                margin: EdgeInsets.only(left: 18),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 65 - 18 - 40 - 5,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                "",
                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
                     "",
                        strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                        style: TextStyle(color: Colors.black.withAlpha(56), letterSpacing: 1.0, fontSize: 13, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
                      ),
                      width: MediaQuery.of(context).size.width - 65 - 18 - 40 - 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 6),
                      child: Text(
                       "",
                        style: TextStyle(color: Colors.black.withAlpha(56), fontSize: 13, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
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
  }


  Text getFeeWidget(int index) {
    return Text(
      "-" + "" + " AE",
      style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
    );
    // if (walletRecordModel.data[index].tx['type'].toString() == "SpendTx") {
    //   // ignore: unrelated_type_equality_checks
    //
    //   if (walletRecordModel.data[index].tx['recipient_id'].toString() == CfxHomePage.address) {
    //     return Text(
    //       "+" + ((walletRecordModel.data[index].tx['amount'].toDouble()) / 1000000000000000000).toString() + " AE",
    //       style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
    //     );
    //   } else {
    //     return Text(
    //       "-" + ((walletRecordModel.data[index].tx['amount'].toDouble()) / 1000000000000000000).toString() + " AE",
    //       style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
    //     );
    //   }
    // } else {
    //   return Text(
    //     "-" + (walletRecordModel.data[index].tx['fee'].toDouble() / 1000000000000000000).toString() + " AE",
    //     style: TextStyle(color: Colors.black.withAlpha(56), fontSize: 14, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu"),
    //   );
    // }
  }

  Future<void> _onRefresh() async {
    netBaseData();
    getAddress();
    eventBus.fire(DefiEvent());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
