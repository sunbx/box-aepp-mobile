import 'package:box/generated/l10n.dart';
import 'package:box/page/home_page.dart';
import 'package:box/page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../main.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _value = "";

  @override
  void initState() {
    super.initState();



    BoxApp.getLanguage().then((String value) {
      print("getLanguage->" + value);
      S.load(Locale(value, value.toUpperCase()));
      setState(() {
        _value = value;
      });
      Future.delayed(Duration(seconds: 1), () {
        S.load(Locale(value, value.toUpperCase()));
//        Navigator.pushReplacement(context,LoginPage());
        BoxApp.getAddress().then((value) {
          if(value.length > 10){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }

        });

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        _value,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
