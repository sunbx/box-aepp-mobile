import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/conflux/cfx_balance_model.dart';
import 'package:box/model/conflux/cfx_dapp_list_model.dart';
import 'package:dio/dio.dart';


class CfxDappListDao {
  static Future<CfxDappListModel> fetch() async {
    Response response = await Dio().get(CFX_DAPP_LIST+"cfx_dapp_cn.json");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      CfxDappListModel model = CfxDappListModel.fromJson(data);
      print(response.toString());
      return model;
    } else {
      throw Exception('Failed to load CfxDappListModel.json');
    }
  }
}