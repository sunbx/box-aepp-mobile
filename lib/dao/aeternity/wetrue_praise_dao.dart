import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/we_true_praise_model.dart';
import 'package:dio/dio.dart';

class WeTruePraiseDao {
  static Future<WeTruePraiseModel> fetch(String hash) async {
    String url = "";

    FormData formData = FormData.fromMap({
      "hash": hash,
      "type": "topic",
    });  var address = await BoxApp.getAddress();
    ///创建 dio
    Options options = Options();
    ///请求header的配置
    options.headers["ak-token"]=address;
    url = WE_TRUE_URL+"/Submit/praise";
    Response response = await Dio().post(url, data: formData,options: options);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      WeTruePraiseModel model = WeTruePraiseModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load WeTruePraiseModel.json');
    }
  }
}
