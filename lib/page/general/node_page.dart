import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:box/dao/aeternity/node_test_dao.dart';
import 'package:box/generated/l10n.dart';
import 'package:box/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NodePage extends StatefulWidget {
  @override
  _NodePageState createState() => _NodePageState();
}

class _NodePageState extends State<NodePage> {
  TextEditingController _textEditingControllerNode = TextEditingController();
  final FocusNode focusNodeNode = FocusNode();
  String dropdownValue = 'custom';
  TextEditingController _textEditingControllerCompiler = TextEditingController();
  final FocusNode focusNodeCompiler = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BoxApp.getNodeUrl().then((nodeUrl) {
      BoxApp.getCompilerUrl().then((compilerUrl) {
        if (nodeUrl == "" || nodeUrl == null) {
          _textEditingControllerNode.text = "https://node.aechina.io";
          dropdownValue = "wetrue";
        } else {
          _textEditingControllerNode.text = nodeUrl;

          if (nodeUrl == "https://node.aeasy.io") {
            dropdownValue = "box";
          }
          if (nodeUrl == "https://mainnet.aeternity.io") {
            dropdownValue = "base";
          }
          if (nodeUrl == "https://node.aechina.io") {
            dropdownValue = "wetrue";
          }
        }
        if (compilerUrl == "" || nodeUrl == null) {
          _textEditingControllerCompiler.text = "https://compiler.aeasy.io";
        } else {
          _textEditingControllerCompiler.text = compilerUrl;
        }

        setState(() {

        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          S.of(context).setting_page_node_set,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          MaterialButton(
            minWidth: 10,
            child: new Text(
              S.of(context).setting_page_node_reset,
              style: TextStyle(
                fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
              ),
            ),
            onPressed: () {
              _textEditingControllerNode.text = "https://node.aechina.io";
              _textEditingControllerCompiler.text = "https://compiler.aeasy.io";
            },
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          focusNodeNode.unfocus();
          focusNodeCompiler.unfocus();
        },
        child: Container(
          // height: MediaQuery.of(context).size.height - MediaQueryData.fromWindow(window).padding.top,
          color: Color(0xFFfafbfc),
          // color: Color(0xFFFFFFFF),
          child: Column(
            children: [


              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 18, top: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      S.of(context).setting_page_node_url,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black.withAlpha(180),
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                      ),
                    ),
                  ),
                  Positioned(
                    right: 18,
                    child: DropdownButton<String>(
                      underline: Container(),
                      value: dropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                        if (dropdownValue == "box") {
                          _textEditingControllerNode.text = "https://node.aeasy.io";
                        }
                        if (dropdownValue == "base") {
                          _textEditingControllerNode.text = "https://mainnet.aeternity.io";
                        }
                        if (dropdownValue == "wetrue") {
                          _textEditingControllerNode.text = "https://node.aechina.io";
                        }
                        if (dropdownValue == "custom") {
                          _textEditingControllerNode.text = "";
                        }
                      },
                      items: <String>['box', 'base', 'wetrue', 'custom'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.only(left: 15, right: 15,top: 10,),
                child: Stack(
                  children: [
                    Container(
                      decoration: new BoxDecoration(
                        color: Color(0xFFedf3f7),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
//                                          autofocus: true,

                        controller: _textEditingControllerNode,
                        focusNode: focusNodeNode,
//              inputFormatters: [
//                WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
//              ],
                        maxLines: 1,
                        style: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          fontSize: 18,
                          fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.only(left: 10.0),
                          contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xFFFC2365)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666).withAlpha(85),
                          ),
                        ),
                        cursorColor: Color(0xFFFC2365),
                        cursorWidth: 2,
                      ),
                    ),

                  ],
                ),
              ),


              Container(
                margin: EdgeInsets.only(left: 18, top: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  S.of(context).setting_page_compiler_url,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withAlpha(180),
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 15, right: 15,top: 12),
                decoration: new BoxDecoration(
                  color: Color(0xFFedf3f7),
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: TextField(
//                                          autofocus: true,

                  controller: _textEditingControllerCompiler,
                  focusNode: focusNodeCompiler,
//              inputFormatters: [
//                WhitelistingTextInputFormatter(RegExp("[0-9.]")), //只允许输入字母
//              ],

                  maxLines: 1,
                  style: TextStyle(
                    textBaseline: TextBaseline.alphabetic,
                    fontSize: 18,
                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.only(left: 10.0),
                    contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10),
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color(0xFFFC2365)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
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

              Container(
                margin: EdgeInsets.only(top: 30, bottom: MediaQueryData.fromWindow(window).padding.bottom + 20),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: FlatButton(
                    onPressed: () {
                      EasyLoading.show();
                      NodeTestDao.fetch(_textEditingControllerNode.text, _textEditingControllerCompiler.text).then((isSucess) {
                        EasyLoading.dismiss();
                        if (isSucess) {
                          BoxApp.setNodeUrl(_textEditingControllerNode.text);
                          BoxApp.setCompilerUrl(_textEditingControllerCompiler.text);
                          BoxApp.setNodeCompilerUrl(_textEditingControllerNode.text, _textEditingControllerCompiler.text);

                          BoxApp.setNodeCompilerUrl(_textEditingControllerNode.text, _textEditingControllerCompiler.text);

                          showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext dialogContext) {
                              return new AlertDialog(shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                                title: Text(S.of(context).dialog_hint),
                                content: Text(
                                  S.of(context).dialog_node_set_sucess,
                                  style: TextStyle(
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: new Text(
                                      S.of(context).dialog_conform,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          ).then((val) {});
                        } else {
                          showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext dialogContext) {
                              return new AlertDialog(shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                                title: Text(S.of(context).dialog_hint),
                                content: Text(
                                  S.of(context).dialog_node_set_error,
                                  style: TextStyle(
                                    fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: new Text(
                                      S.of(context).dialog_conform,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          ).then((val) {});
                        }


                      }).catchError((e) {
                        showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext dialogContext) {
                            return new AlertDialog(shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                              title: Text(S.of(context).dialog_hint),
                              content: Text(
                                S.of(context).dialog_node_set_error,
                                style: TextStyle(
                                  fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu",
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: new Text(
                                    S.of(context).dialog_conform,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ).then((val) {});
                      });

                      return;
                    },
                    child: Text(
                      S.of(context).setting_page_node_save,
                      maxLines: 1,
                      style: TextStyle(fontSize: 16, fontFamily: BoxApp.language == "cn" ? "Ubuntu" : "Ubuntu", color: Color(0xffffffff)),
                    ),
                    color: Color(0xFFFC2365),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Material buildItem(String key, bool isSelect, GestureTapCallback tab) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: tab,
        child: Container(
          padding: const EdgeInsets.only(left: 18, right: 21, top: 20, bottom: 20),
          child: Row(
            children: [
              /*1*/
              Column(
                children: [
                  /*2*/
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      key,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: BoxApp.language == "cn" ? "Ubuntu":"Ubuntu",
                      ),
                    ),
                  ),
                ],
              ),
              /*3*/
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Image(
                    width: 25,
                    height: 25,
                    image: AssetImage(isSelect ? "images/check_box_select.png" : "images/check_box_normal.png"),
                  ),
                  margin: const EdgeInsets.only(left: 30.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
