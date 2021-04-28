import 'dart:ui';

import 'package:box/event/language_event.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/page/token_defi_page_v2.dart';
import 'package:box/utils/utils.dart';
import 'package:box/widget/pay_password_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:package_info/package_info.dart';

import '../main.dart';
import 'home_page.dart';
import 'language_page.dart';
import 'mnemonic_copy_page.dart';
import 'node_page.dart';

class SettingPageV2 extends StatefulWidget {
  @override
  _SettingPageV2State createState() => _SettingPageV2State();
}

class _SettingPageV2State extends State<SettingPageV2> with AutomaticKeepAliveClientMixin {
  var mnemonic = "";
  var version = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMnemonic();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
    eventBus.on<LanguageEvent>().listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xfffafafa),
        elevation: 0,
        // 隐藏阴影
        leading:BoxApp.isOpenStore?null: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,

            size: 17,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).setting_page_title,
          style: TextStyle(fontSize: 18,fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",),
        ),
        centerTitle: true,


      ),
      body: Container(

        child: Column(
          children: <Widget>[
            Container(
              height: 15,
            ),

            buildItem(context, S.of(context).setting_page_item_save, "images/setting_save.png", () {
              showGeneralDialog(
                  context: context,
                  pageBuilder: (context, anim1, anim2) {},
                  barrierColor: Colors.grey.withOpacity(.4),
                  barrierDismissible: true,
                  barrierLabel: "",
                  transitionDuration: Duration(milliseconds: 400),
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
                            var mnemonic = await BoxApp.getMnemonic();
                            if (mnemonic == "") {
                              showPlatformDialog(
                                context: context,
                                builder: (_) => BasicDialogAlert(
                                  title: Text(S.of(context).dialog_hint),
                                  content: Text(S.of(context).dialog_login_user_no_save),
                                  actions: <Widget>[
                                    BasicDialogAction(
                                      title: Text(
                                        S.of(context).dialog_conform,
                                        style: TextStyle(color: Color(0xFFFC2365)),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context, rootNavigator: true).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                            var address = await BoxApp.getAddress();
                            final key = Utils.generateMd5Int(password + address);
                            var aesDecode = Utils.aesDecode(mnemonic, key);

                            if (aesDecode == "") {
                              showPlatformDialog(
                                context: context,
                                builder: (_) => BasicDialogAlert(
                                  title: Text(S.of(context).dialog_hint_check_error),
                                  content: Text(S.of(context).dialog_hint_check_error_content),
                                  actions: <Widget>[
                                    BasicDialogAction(
                                      title: Text(
                                        S.of(context).dialog_conform,
                                        style: TextStyle(color: Color(0xFFFC2365)),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context, rootNavigator: true).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MnemonicCopyPage(mnemonic: aesDecode)));
                          },
                        ),
                      ),
                    );
                  });
            }, isLine: false),

            Container(
//              color: Colors.white,
              height: 5,
            ),
            buildItem(context, S.of(context).setting_page_node_set, "images/setting_node.png", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NodePage()));
            }, isLine: false),
            Container(
//              color: Colors.white,
              height: 5,
            ),
            buildItem(context, S.of(context).setting_page_item_language, "images/setting_lanuage.png", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagePage()));
            }, isLine: false),
            Container(
//              color: Colors.white,
              height: 5,
            ),
            Material(
              child: InkWell(
                child: Container(
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: <Widget>[
//                            Image(
//                              width: 30,
//                              height: 30,
//                              image: AssetImage("images/setting_version.png"),
//                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 7),
                              child: Text(
                                S.of(context).setting_page_item_version,
                                style: new TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        right: 35,
                        child: Text("v" + version),
                      ),
                    ],
                  ),
                ),
              ),
            ),
//            buildItem(context, "关于", "images/profile_info.png", () {
//              print("123");
//            }, isLine: true),
            Container(
//              color: Colors.white,
              height: 5,
            ),
            Material(
              child: InkWell(
                onTap: () {
                  HomePage.tokenABC = "loading...";
                  TokenDefiPage.model = null;
                  BoxApp.setAddress("");
                  BoxApp.setSigningKey("");
                  BoxApp.setMnemonic("");
                  Navigator.of(super.context).pushNamedAndRemoveUntil("/login", ModalRoute.withName("/login"));
                },
                child: Container(
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: <Widget>[
//                    Image(
//                      width: 30,
//                      height: 30,
//                      image: AssetImage(assetImage),
//                    ),
                            Container(
                              padding: const EdgeInsets.only(left: 7),
                              child: Text(
                                S.of(context).setting_page_item_logout,
                                style: new TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
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
//            Expanded(child: Container()),

//            Container(
//              height: 44,
//              width: MediaQuery.of(context).size.width * 0.8 - 80,
//              margin: EdgeInsets.only(top: 70, bottom: MediaQueryData.fromWindow(window).padding.bottom + 50),
//              child: FlatButton(
//                onPressed: () {
//                  HomePage.tokenABC = "loading...";
//                  TokenDefiPage.model = null;
//                  BoxApp.setAddress("");
//                  BoxApp.setSigningKey("");
//                  BoxApp.setMnemonic("");
//                  Navigator.of(super.context).pushNamedAndRemoveUntil("/login", ModalRoute.withName("/login"));
//                },
//                child: Text(
//                  S.of(context).setting_page_item_logout,
//                  maxLines: 1,
//                  style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu", color: Color(0xFFF22B79)),
//                ),
//                color: Color(0xFFE61665).withAlpha(16),
//                textColor: Colors.black,
//                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//              ),
//            ),
          ],
        ),
      ),
    );
  }

  Future<String> getMnemonic() {
    BoxApp.getAddress().then((String mnemonic) {
      setState(() {
        this.mnemonic = mnemonic;
      });
    });
  }

  Material buildItem(BuildContext context, String content, String assetImage, GestureTapCallback tab, {bool isLine = true}) {
    return Material(
      child: InkWell(
        onTap: tab,
        child: Container(
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: <Widget>[
//                    Image(
//                      width: 30,
//                      height: 30,
//                      image: AssetImage(assetImage),
//                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        content,
                        style: new TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 30,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Color(0xFFe0e0e0),
                ),
              ),
              if (isLine)
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: Container(height: 1.0, width: MediaQuery.of(context).size.width - 30, color: Color(0xFFF5F5F5)),
                )
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
