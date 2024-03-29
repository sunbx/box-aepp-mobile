import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/main.dart';
import 'package:box/model/aeternity/aens_info_model.dart';
import 'package:box/model/aeternity/swap_model.dart';
import 'package:dio/dio.dart';

class SwapDao {
  static Future<SwapModel> fetch(String coinAdress) async {
    Map<String, String> params = new Map();
    params['ct_id'] = BoxApp.SWAP_CONTRACT;
    params['coin_address'] = coinAdress;
    params['address'] =await BoxApp.getAddress();
    Response response = await Dio().post(SWAP_LIST, queryParameters: params);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.toString());
      SwapModel model = SwapModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load SwapModel.json');
    }
  }
}
