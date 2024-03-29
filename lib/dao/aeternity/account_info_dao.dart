import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class AccountInfoDao {
  static Future<AccountInfoModel> fetch({String address = ''}) async {
    Map<String, String> params = new Map();
    if(address.isEmpty){
      address = await BoxApp.getAddress();
    }
    params["address"] = address;
    Response response = await Dio().post(ACCOUNT_INFO,queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      AccountInfoModel model = AccountInfoModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load AccountInfoModel.json');
    }
  }
}
