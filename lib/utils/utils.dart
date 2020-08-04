import 'package:flutter/material.dart';

class Utils {
  static formatAddress(String address) {
    return "ak_***" + address.substring(address.length - 4, address.length);
  }

  static formatHomeAddress(String address) {
    return "ak_" + address.substring(3, 8)+"...."+ address.substring(address.length - 8, address.length);
  }

  static formatPrice(String price) {
    return price.substring(0, price.length - 3);
  }

  static String formatHeight(int startHeight, int endHeight) {
    var height = endHeight - startHeight;
    if (height < 1) {
      return "3分钟";
    }
    //秒
    var time = height * 3;
    if (time > 60 * 24) {
      return (time / (60 * 24)).toInt().toString() + "天";
    }
    if (time > 60) {
      return (time / (60)).toInt().toString() + "小时";
    }
    return (time).toInt().toString() + "分钟";
  }
}
