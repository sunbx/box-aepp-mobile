import 'dart:ui';

import 'package:box/dao/aeternity/allowance_dao.dart';
import 'package:box/dao/aeternity/contract_balance_dao.dart';
import 'package:box/dao/aeternity/swap_coin_dao.dart';
import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/model/aeternity/allowance_model.dart';
import 'package:box/model/aeternity/contract_balance_model.dart';
import 'package:box/model/aeternity/swap_coin_model.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/chain_loading_widget.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../main.dart';

class AeSwapInitiatePage extends StatefulWidget {
  @override
  _AeSwapInitiatePageState createState() => _AeSwapInitiatePageState();
}

class _AeSwapInitiatePageState extends State<AeSwapInitiatePage> {
  TextEditingController _textEditingControllerNode = TextEditingController();
  final FocusNode focusNodeNode = FocusNode();
  TextEditingController _textEditingControllerCompiler = TextEditingController();
  final FocusNode focusNodeCompiler = FocusNode();


  TextEditingController _textEditingControllerCompiler2 = TextEditingController();
  final FocusNode focusNodeCompiler2 = FocusNode();
  String ctBalance = "loading...";

  SwapCoinModel swapCoinModel;
  SwapCoinModelData dropdownValue;
  List<DropdownMenuItem<SwapCoinModelData>> coins = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () {
      //请求获取焦点
      FocusScope.of(context).requestFocus(focusNodeNode);
    });
    _onRefresh();

    _textEditingControllerCompiler2.addListener(() {
      try{

        var tokenCount = double.parse(_textEditingControllerNode.text);

        var pre = double.parse(_textEditingControllerCompiler2.text);

        setState(() {
          _textEditingControllerCompiler.text =( pre* tokenCount).toStringAsFixed(2);

        });

      }catch(e){
        setState(() {
          _textEditingControllerCompiler.text ="";

        });
      }

    });


    _textEditingControllerNode.addListener(() {
      try{

        var tokenCount = double.parse(_textEditingControllerNode.text);

        var pre = double.parse(_textEditingControllerCompiler2.text);

        setState(() {
          _textEditingControllerCompiler.text =( pre* tokenCount).toStringAsFixed(2);

        });

      }catch(e){
        setState(() {
          _textEditingControllerCompiler.text ="";

        });
      }

    });
  }

  void netContractBalance() {
    ctBalance = "loading...";
    ContractBalanceDao.fetch(dropdownValue.ctAddress).then((ContractBalanceModel model) {
      if (model.code == 200) {
        ctBalance = model.data.balance;
        _textEditingControllerCompiler2.text = model.data.rate;
        setState(() {});
      } else {}
    }).catchError((e) {
//      Fluttertoast.showToast(msg: "网络错误" + e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
    });
  }

  Future<void> _onRefresh() async {
    SwapCoinDao.fetch().then((SwapCoinModel model) {
      if (dropdownValue == null) {
        swapCoinModel = model;
        dropdownValue = model.data[0];
        model.data.forEach((element) {
          final DropdownMenuItem<SwapCoinModelData> item = DropdownMenuItem(
            child: Text(element.name),
            value: element,
          );
          coins.add(item);
        });
        netContractBalance();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFfafbfc),
      appBar: AppBar(
        backgroundColor: Color(0xFFfafbfc),
        // 隐藏阴影
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).swap_title_send,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          focusNodeNode.unfocus();
          focusNodeCompiler.unfocus();
          focusNodeCompiler2.unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top,
          color:  Color(0xFFfafbfc),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 18, top: 0),
                alignment: Alignment.topLeft,
                child: Text(
                  S.of(context).swap_send_1,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12, left: 15, right: 15),
                child: Stack(
                  children: [
                    Container(
                      height: 45,
//                      padding: EdgeInsets.only(left: 10, right: 10),
                      //边框设置
                      decoration: new BoxDecoration(
                        color: Color(0xFFedf3f7),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: _textEditingControllerNode,
                        focusNode: focusNodeNode,
//              inputFormatters: [
//                WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
//              ],
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp("[0-9]")), //只允许输入字母
                        ],
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10.0),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color(0xFFeeeeee),
                            ),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Color(0xFFFC2365)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: dropdownValue == null ? S.of(context).swap_text_hint : S.of(context).swap_text_hint + " > " + dropdownValue.lowTokenCount.toString(),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666).withAlpha(85),
                          ),
                        ),
                        cursorColor: Color(0xFFFC2365),
                        cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      child: swapCoinModel == null
                          ? Container()
                          : Container(
                              height: 45,
                              child: DropdownButton<SwapCoinModelData>(
                                underline: Container(),
                                value: dropdownValue,
                                onChanged: (SwapCoinModelData newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                  netContractBalance();
                                },
                                items: coins,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 26, top: 10, right: 26),
                alignment: Alignment.topRight,
                child: Text(
                  S.of(context).token_send_two_page_balance + " : " + ctBalance,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
              ),

              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 18, top: 18),
                    alignment: Alignment.topLeft,
                    child: Text(
                      S.of(context).swap_send_2,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: EdgeInsets.only(right: 18, top: 18),
                    alignment: Alignment.topLeft,
                    child: Text(
                      S.of(context).swap_send_2_2,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/3*2,
                    margin: EdgeInsets.only(top: 12, left: 18, right: 10),
                    child: Stack(
                      children: [
                        Container(
//                      padding: EdgeInsets.only(left: 10, right: 10),
                          //边框设置
                          height: 45,
                          decoration: new BoxDecoration(
                            color: Color(0xFFedf3f7),
                            //设置四周圆角 角度
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
//                                          autofocus: true,

                            controller: _textEditingControllerCompiler,
                            focusNode: focusNodeCompiler,
                            inputFormatters: [
                              WhitelistingTextInputFormatter(RegExp("[0-9]")), //只允许输入字母
                            ],

                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10.0),
                              enabledBorder: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Color(0xFFeeeeee),
                                ),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Color(0xFFFC2365)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              hintText: dropdownValue == null ? S.of(context).swap_text_hint : S.of(context).swap_text_hint + " > " + dropdownValue.lowAeCount.toString(),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666).withAlpha(85),
                              ),
                            ),
                            cursorColor: Color(0xFFFC2365),
                            cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                          ),
                        ),
                        Positioned(
                          right: 15,
                          child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              child: Text(
                                "AE",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  color: Colors.black,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/3-10-18-18,
                    margin: EdgeInsets.only(top: 12,  right: 18),
                    child: Stack(
                      children: [
                        Container(
//                      padding: EdgeInsets.only(left: 10, right: 10),
                          //边框设置
                          height: 45,
                          decoration: new BoxDecoration(
                            color: Color(0xFFedf3f7),
                            //设置四周圆角 角度
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
//                                          autofocus: true,

                            controller: _textEditingControllerCompiler2,
                            focusNode: focusNodeCompiler2,
                            inputFormatters: [
                              WhitelistingTextInputFormatter(RegExp("[0-9\.]")), //只允许输入字母
                            ],

                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10.0),
                              enabledBorder: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Color(0xFFeeeeee),
                                ),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Color(0xFFFC2365)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666).withAlpha(85),
                              ),
                            ),
                            cursorColor: Color(0xFFFC2365),
                            cursorWidth: 2,
//                                cursorRadius: Radius.elliptical(20, 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width - 45,
                margin: const EdgeInsets.only(top: 28),
                child:Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: FlatButton(
                    onPressed: () {

//                      clickNext();
                    netSell();
                    },
                    child: Text(
                      S.of(context).swap_send_3,
                      maxLines: 1,
                      style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
                    ),
                    color: Color(0xFFFC2365),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18, top: 18),
                alignment: Alignment.topLeft,
                child: Text(
                  S.of(context).swap_send_4,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 8),
                alignment: Alignment.topLeft,
                child: Text(
                  S.of(context).swap_send_5,
                  style: TextStyle(fontSize: 14, letterSpacing: 1.0, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", height: 1.5, color: Color(0xFF999999)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void netSell() {
    focusNodeNode.unfocus();
    focusNodeCompiler.unfocus();

    if (ctBalance == "loading...") {
      return;
    }
    var inputTokenBalanceString = _textEditingControllerNode.text;
    if (double.parse(ctBalance) < double.parse(inputTokenBalanceString)) {
      return;
    }
    EasyLoading.show();
    AllowanceDao.fetch(dropdownValue.ctAddress).then((AllowanceModel model) {
      EasyLoading.dismiss(animation: true);
      showGeneralDialog(useRootNavigator:false,
          context: context,
          // ignore: missing_return
          pageBuilder: (context, anim1, anim2) {},
          //barrierColor: Colors.grey.withOpacity(.4),
          barrierDismissible: true,
          barrierLabel: "",
          transitionDuration: Duration(milliseconds: 0),
          transitionBuilder: (_, anim1, anim2, child) {
            final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
            return Transform(
              transform: Matrix4.translationValues(0.0, 0, 0.0),
              child: Opacity(
                opacity: anim1.value,
                // ignore: missing_return
                child: PayPasswordWidget(
                  title: S.of(context).password_widget_input_password,
                  dismissCallBackFuture: (String password) {
                    return;
                  },
                  passwordCallBackFuture: (String password) async {
                    var signingKey = await BoxApp.getSigningKey();
                    var address = await BoxApp.getAddress();
                    final key = Utils.generateMd5Int(password + address);
                    var aesDecode = Utils.aesDecode(signingKey, key);

                    if (aesDecode == "") {
                      showErrorDialog(context, null);
                      return;
                    }
                    // ignore: missing_return
                    BoxApp.contractSwapSell((tx) {
                      focusNodeNode.unfocus();
                      focusNodeCompiler.unfocus();

                      showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                          return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                            title: Text(S.of(context).dialog_hint),
                            content: Text(   S.of(context).dialog_send_sucess,),
                            actions: <Widget>[
                              TextButton(
                                child: new Text(
                                  S.of(context).dialog_conform,
                                ),
                                onPressed: () {
                                  focusNodeNode.unfocus();
                                  focusNodeCompiler.unfocus();
                                  eventBus.fire(SwapEvent());

                                  Navigator.of(context, rootNavigator: true).pop();
                                },
                              ),
                            ],
                          );
                        },
                      ).then((val) {
                        Navigator.pop(context);
                      });
                    }, (error) {
                      showErrorDialog(context, error);
                      return;
                    }, aesDecode, address, BoxApp.SWAP_CONTRACT, dropdownValue.ctAddress, _textEditingControllerNode.text, _textEditingControllerCompiler.text,model.data.allowance);
                    showChainLoading();
                  },
                ),
              ),
            );
          });
    }).catchError((error){
      EasyLoading.dismiss(animation: true);
    });




  }

  void showChainLoading() {
    showGeneralDialog(useRootNavigator:false,
        context: context,
        // ignore: missing_return
        pageBuilder: (context, anim1, anim2) {},
        //barrierColor: Colors.grey.withOpacity(.4),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 0),
        transitionBuilder: (_, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
          return ChainLoadingWidget();
        });
  }
  void showErrorDialog(BuildContext buildContext, String content) {
    if (content == null) {
      content = S.of(buildContext).dialog_hint_check_error_content;
    }
    showDialog<bool>(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return new AlertDialog(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
          title: Text(S.of(buildContext).dialog_hint_check_error),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: new Text(
                S.of(buildContext).dialog_conform,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    ).then((val) {});
  }
}
