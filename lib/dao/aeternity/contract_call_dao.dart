import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/aeternity/account_info_model.dart';
import 'package:box/model/aeternity/block_top_model.dart';
import 'package:box/model/aeternity/contract_balance_model.dart';
import 'package:box/model/aeternity/contract_call_model.dart';
import 'package:box/model/aeternity/contract_info_model.dart';
import 'package:box/model/aeternity/contract_record_model.dart';
import 'package:box/model/aeternity/msg_sign_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

class ContractCallDao {
  static Future<MsgSignModel> fetch(String function, String paramsValue, String address, String amount) async {
    Map<String, String> params = new Map();
    params["function"] = function;
    params["params"] = paramsValue;
    params["address"] = address;
    params["amount"] = amount;
    Response response = await Dio().post(CONTRACT_CALL, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());

      MsgSignModel model = MsgSignModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ContractCallModel.json');
    }
  }
  static Future<MsgSignModel> fetchCtID(String function, String paramsValue, String address, String amount) async {
    Map<String, String> params = new Map();
    params["function"] = function;
    params["ct_id"] = "ct_Evidt2ZUPzYYPWhestzpGsJ8uWzB1NgMpEvHHin7GCfgWLpjv";
    params["params"] = paramsValue;
    params["address"] = address;
    params["amount"] = amount;
    Response response = await Dio().post(CONTRACT_CALL, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());

      MsgSignModel model = MsgSignModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ContractCallModel.json');
    }
  }
}
