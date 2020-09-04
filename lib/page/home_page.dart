import 'dart:async';
import 'dart:ui';

import 'package:box/dao/account_info_dao.dart';
import 'package:box/dao/base_data_dao.dart';
import 'package:box/dao/base_name_data_dao.dart';
import 'package:box/dao/block_top_dao.dart';
import 'package:box/dao/wallet_record_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/base_data_model.dart';
import 'package:box/model/base_name_data_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/wallet_record_model.dart';
import 'package:box/page/aens_page.dart';
import 'package:box/page/login_page.dart';
import 'package:box/page/records_page.dart';
import 'package:box/page/search_page.dart';
import 'package:box/page/settings_page.dart';
import 'package:box/page/token_receive_page.dart';
import 'package:box/page/token_send_one_page.dart';
import 'package:box/page/tx_detail_page.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/bottom_navigation_widget.dart';
import 'package:box/widget/loading_widget.dart';
import 'package:box/widget/password_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:box/widget/taurus_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_color_plugin/flutter_color_plugin.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../main.dart';
import 'aens_register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TextEditingController _textEditingController = TextEditingController();
  var loadingType = LoadingType.loading;
  EasyRefreshController _easyRefreshController = EasyRefreshController();
  WalletTransferRecordModel walletRecordModel;
  BlockTopModel baseDataModel;
  BaseNameDataModel baseNameDataModel;
  var token = "loading...";
  var address = '';
  var page = 1;

  var contentText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });
    getAddress();
    netAccountInfo();
    netBaseData();
    netBaseNameData();
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
        if (page == 1) {
          page++;
          if (model.data == null || model.data.length == 0) {
            loadingType = LoadingType.no_data;
            _easyRefreshController.finishRefresh();
            _easyRefreshController.finishLoad();
            setState(() {});
            return;
          }
          walletRecordModel = model;
        } else {
          walletRecordModel.data.addAll(model.data);
        }

        setState(() {});
      } else {}
    }).catchError((e) {
      loadingType = LoadingType.error;
      setState(() {});
      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  void netBaseNameData() {
    BaseNameDataDao.fetch().then((BaseNameDataModel model) {
      baseNameDataModel = model;
      setState(() {

      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void netBaseData() {
    BlockTopDao.fetch().then((BlockTopModel model) {
      if (model.code == 200) {
        baseDataModel = model;
//        setState(() {});
        netWalletRecord();
      } else {}
    }).catchError((e) {
      loadingType = LoadingType.error;
      setState(() {});
      Fluttertoast.showToast(msg: "error" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
//    _top = 356.00;
//    netWalletRecord();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Container(
            child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQueryData.fromWindow(window).padding.top,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 18),
                          alignment: Alignment.topLeft,
                          child: Image(
                            width: 153,
                            height: 36,
                            image: AssetImage('images/home_logo_left.png'),
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
                              color: Colors.black,
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
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 55 - MediaQueryData.fromWindow(window).padding.top,
              width: MediaQuery.of(context).size.width,
              child: EasyRefresh(
                header: TaurusHeader(backgroundColor: Color(0xFFFC2365)),
                onRefresh: _onRefresh,
                child: Container(
//                height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          height: 200,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                          margin: const EdgeInsets.only(top: 0, bottom: 0),
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/wallet_card.png"),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(top: 28, left: 18),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      S.of(context).home_page_my_count + " (AE)",
                                      style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: "Ubuntu"),
                                    ),
                                    Text("")
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8, left: 18),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
//                            buildTypewriterAnimatedTextKit(),
                                    Text(
                                      token,
                                      style: TextStyle(fontSize: 35, color: Colors.white, fontFamily: "Ubuntu"),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8, left: 15, right: 15),
                                child: Text(
                                  address,
                                  strutStyle: StrutStyle(forceStrutHeight: true, height: 0.5, leading: 1, fontFamily: "Ubuntu"),
                                  style: TextStyle(fontSize: 13, letterSpacing: 1.0, color: Colors.white70, fontFamily: "Ubuntu", height: 1.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 167,
                            ),
                            Container(
                              height: 90,
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => TokenReceivePage()));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 90,
                                              alignment: Alignment.center,
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
                                                    padding: const EdgeInsets.only(left: 5),
                                                    child: Text(
                                                      S.of(context).home_page_function_defi,
                                                      style: new TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Ubuntu", color: Colors.black),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 18,
                                              child: Container(
                                                height: 30,
                                                margin: const EdgeInsets.only(top: 0),
                                                child: FlatButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    S.of(context).home_page_function_defi_go,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13, fontFamily: "Ubuntu", color: Color(0xFFF22B79)),
                                                  ),
                                                  color: Color(0xFFE61665).withAlpha(16),
                                                  textColor: Colors.black,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 90,
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => TokenSendOnePage()));
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
                                              Container(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Text(
                                                  S.of(context).home_page_function_send,
                                                  style: new TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Ubuntu", color: Colors.black),
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
                            Container(
                              height: 160,
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => TokenReceivePage()));
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
                                                      image: AssetImage("images/home_receive_token.png"),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.only(left: 0),
                                                    child: Text(
                                                      S.of(context).home_page_function_receive,
                                                      style: new TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Ubuntu", color: Colors.black),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 18,
                                              child: Container(
                                                height: 30,
                                                margin: const EdgeInsets.only(top: 20),
                                                child: FlatButton(
                                                  onPressed: () {
                                                    Clipboard.setData(ClipboardData(text: address));
                                                    setState(() {
                                                      contentText = S.of(context).token_receive_page_copy_sucess;
                                                    });
                                                    Fluttertoast.showToast(msg: S.of(context).token_receive_page_copy_sucess, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
                                                  },
                                                  child: Text(
                                                    contentText == "" ? S.of(context).token_receive_page_copy : S.of(context).token_receive_page_copy_sucess,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 13, fontFamily: "Ubuntu", color: Color(0xFFF22B79)),
                                                  ),
                                                  color: Color(0xFFE61665).withAlpha(16),
                                                  textColor: Colors.black,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(top: 5, left: 18, right: 5),
                                              child: Text(
                                                address,
                                                strutStyle: StrutStyle(forceStrutHeight: true, height: 0.8, leading: 1, fontFamily: "Ubuntu"),
                                                style: TextStyle(fontSize: 14, color: Color(0xFF999999), letterSpacing: 1.0, fontFamily: "Ubuntu", height: 1.3),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 0, right: 23),
                                            child: QrImage(
                                              data: address,
                                              version: QrVersions.auto,
                                              size: 80.0,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 130,
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(top: 12, left: 15, right: 15),
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AensPage()));
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
                                                      image: AssetImage("images/home_names.png"),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.only(left: 0),
                                                    child: Text(
                                                      S.of(context).home_page_function_names,
                                                      style: new TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Ubuntu", color: Colors.black),
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
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  margin: const EdgeInsets.only(top: 0, left: 20),
                                                  child: Text(
                                                    S.of(context).home_page_function_name,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      wordSpacing: 30.0, //词间距
                                                      color: Color(0xFF666666),
                                                      fontFamily: "Ubuntu",
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  margin: const EdgeInsets.only(top: 5, left: 20),
                                                  child: Text(
                                                    baseNameDataModel == null ? "-" :baseNameDataModel.data.sum.toString()  + S.of(context).home_page_function_name_count_number,
                                                    style: TextStyle(
                                                      fontSize: 19,
                                                      letterSpacing: -1,
                                                      //字体间距
                                                      fontWeight: FontWeight.bold,

                                                      //词间距
                                                      color: Color(0xFF000000),
                                                      fontFamily: "Ubuntu",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  margin: const EdgeInsets.only(top: 0, left: 20),
                                                  child: Text(
                                                    S.of(context).home_page_function_name_count + "(ae)",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      wordSpacing: 30.0, //词间距
                                                      color: Color(0xFF666666),
                                                      fontFamily: "Ubuntu",
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  margin: const EdgeInsets.only(top: 5, left: 20),
                                                  child: Text(
                                                    baseNameDataModel == null ? "-" :baseNameDataModel.data.sumPrice.toString() + S.of(context).home_page_function_name_count_number,
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        letterSpacing: -1,
                                                        //字体间距
                                                        fontWeight: FontWeight.bold,

                                                        //词间距
                                                        color: Color(0xFF000000),
                                                        fontFamily: "Ubuntu"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 86,
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            getRecordContainer(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Container getRecordContainer(BuildContext context) {
    if (walletRecordModel == null && page == 1 && baseDataModel == null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: LoadingWidget(
          type: LoadingType.loading,
        ),
      );
    }
    if( walletRecordModel== null){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,

      );
    }
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 12, left: 15, right: 15, bottom: 40),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => RecordsPage()));
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
                              style: new TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Ubuntu", color: Colors.black),
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
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 15, top: 0),
                child: Text(
                  S.of(context).home_page_transaction_conform,
                  style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontFamily: "Ubuntu"),
                ),
                height: 23,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
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

  Widget getItem(BuildContext context, int index) {
    if (walletRecordModel == null || walletRecordModel.data.length < index) {
      return Container();
    }
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TxDetailPage(recordData: walletRecordModel.data[index])));
        },
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //边框设置

                child: Text(
                  (baseDataModel.data.height - walletRecordModel.data[index].blockHeight).toString(),
                  style: TextStyle(color: Color(0xFFFC2365), fontSize: 14, fontFamily: "Ubuntu"),
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
                                walletRecordModel.data[index].tx['type'],
                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "Ubuntu"),
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
                        style: TextStyle(color: Colors.black.withAlpha(56), letterSpacing: 1.0, fontSize: 13, fontFamily: "Ubuntu"),
                      ),
                      width: 250,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 6),
                      child: Text(
                        DateTime.fromMicrosecondsSinceEpoch(walletRecordModel.data[index].time * 1000).toLocal().toString(),
                        style: TextStyle(color: Colors.black.withAlpha(56), fontSize: 13, letterSpacing: 1.0, fontFamily: "Ubuntu"),
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

  Future<void> _onLoad() async {
    await Future.delayed(Duration(seconds: 1), () {

      netWalletRecord();
    });
  }

  Future<String> getAddress() {
    BoxApp.getAddress().then((String address) {
      setState(() {
        this.address = address;
      });
    });
  }

  Future<void> _onRefresh() async {
    page = 1;
    if (page == 1 && walletRecordModel == null) {
      loadingType = LoadingType.loading;
    }
    setState(() {});
    await Future.delayed(Duration(seconds: 1), () {
      netAccountInfo();
      netBaseData();
      getAddress();
      netBaseNameData();
    });
  }

  double getListWidgetHeight(BuildContext context) {
    if (loadingType == LoadingType.finish) {
      return MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top - 50 - 200;
    } else {
      return MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top - 50 - 150 - 200;
    }
  }

  Text getFeeWidget(int index) {
    if (walletRecordModel.data[index].tx['type'].toString() == "SpendTx") {
      // ignore: unrelated_type_equality_checks

      if (walletRecordModel.data[index].tx['recipient_id'].toString() == address) {
        return Text(
          "+" + ((walletRecordModel.data[index].tx['amount'].toDouble()) / 1000000000000000000).toString() + " AE",
          style: TextStyle(color: Colors.red, fontSize: 14, fontFamily: "Ubuntu"),
        );
      } else {
        return Text(
          "-" + ((walletRecordModel.data[index].tx['amount'].toDouble()) / 1000000000000000000).toString() + " AE",
          style: TextStyle(color: Colors.green, fontSize: 14, fontFamily: "Ubuntu"),
        );
      }
    } else {
      return Text(
        "-" + (walletRecordModel.data[index].tx['fee'].toDouble() / 1000000000000000000).toString() + " AE",
        style: TextStyle(color: Colors.black.withAlpha(56), fontSize: 14, fontFamily: "Ubuntu"),
      );
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
