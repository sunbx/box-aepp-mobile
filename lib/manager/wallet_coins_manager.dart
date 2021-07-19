import 'dart:convert';

import 'package:box/model/wallet_coins_model.dart';
import 'package:box/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class WalletCoinsManager {
  WalletCoinsManager._privateConstructor();

  static final WalletCoinsManager instance = WalletCoinsManager._privateConstructor();

  Future<bool> init() async {
    var prefs = await SharedPreferences.getInstance();
    var walletCoinsJson = prefs.getString('wallet_coins');

    WalletCoinsModel model;
    if (walletCoinsJson == null || walletCoinsJson == "") {
      model = new WalletCoinsModel();
    } else {
      var data = jsonDecode(walletCoinsJson.toString());
      model = WalletCoinsModel.fromJson(data);
    }

    if (model.coins == null) {
      model.coins = [];
      var signingKey = prefs.getString('signingKey');
      var address = prefs.getString('address');
      var mnemonic = prefs.getString('mnemonic');
      if (address != null && address != "") {
        Account account = Account();
        account.address = address;
        account.isSelect = true;
        account.coin = "AE";

        Coin coin = new Coin();
        coin.fullName = "Aeternity";
        coin.name = "AE";

        coin.accounts = [];
        coin.accounts.add(account);

        model.coins.add(coin);
        await setCoins(model);
        await setMnemonicAndSigningKey(address, mnemonic, signingKey);
      }
    }
    return true;
  }

  setMnemonicAndSigningKey(String address, String mnemonic, String signingKey) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(Utils.generateMD5(address + "mnemonic"), mnemonic);
    prefs.setString(Utils.generateMD5(address + "signingKey"), signingKey);
  }

  Future<WalletCoinsModel> getCoins() async {
    var prefs = await SharedPreferences.getInstance();
    var walletCoinsJson = prefs.getString('wallet_coins');
    WalletCoinsModel model;
    if (walletCoinsJson == null || walletCoinsJson == "") {
      model = new WalletCoinsModel();
    } else {
      var data = jsonDecode(walletCoinsJson.toString());
      model = WalletCoinsModel.fromJson(data);
    }
    return model;
  }

  Future<bool> setCoins(WalletCoinsModel model) async {
    var prefs = await SharedPreferences.getInstance();
    if (model == null) {
      return prefs.setString('wallet_coins', "");
    } else {
      return prefs.setString('wallet_coins', jsonEncode(model));
    }
  }

  Future<bool> addAccount(String coinName, String fullName, String address, String mnemonic, String signingKey) async {
    WalletCoinsModel coins = await getCoins();

    if (coins.coins == null) {
      Coin coin = new Coin();
      coin.fullName = fullName;
      coin.name = coinName;
      Account account = Account();
      account.address = address;
      account.isSelect = true;
      account.coin = coinName;
      coin.accounts = [];
      coin.accounts.add(account);
      if (coins.coins == null) {
        coins.coins = [];
      }
      coins.coins.add(coin);
      await setMnemonicAndSigningKey(address, mnemonic, signingKey);
    } else {
      for (var i = 0; i < coins.coins.length; i++) {
        if (coinName == coins.coins[i].name) {
          Account account = Account();
          account.address = address;
          account.isSelect = true;
          account.coin = coinName;
          if (coins.coins[i].accounts == null) {
            coins.coins[i].accounts = [];
          }
          for (var j = 0; j < coins.coins.length; j++) {
            coins.coins[i].accounts[j].isSelect = false;
          }
          coins.coins[i].accounts.add(account);
          await setMnemonicAndSigningKey(address, mnemonic, signingKey);
        }
      }
    }
    await updateAccount(coins, address);
    return true;
  }

  Future<bool> updateAccount(WalletCoinsModel walletCoinsModel, String address) async {
    setCoins(walletCoinsModel);
    BoxApp.setSigningKey(Utils.generateMD5(address + "signingKey"));
    BoxApp.setMnemonic(Utils.generateMD5(address + "mnemonic"));
    BoxApp.setAddress(address);
    return true;
  }

  Future<Account> getCurrentAccount() async {
    WalletCoinsModel coins = await getCoins();
    for (var i = 0; i < coins.coins.length; i++) {
      for (var j = 0; j < coins.coins[i].accounts.length; j++) {
        if (coins.coins[i].accounts[j].isSelect) {
          return coins.coins[i].accounts[j];
        }
      }
    }
    return null;
  }

  Future<List<Object>> getCurrentCoin() async {
    WalletCoinsModel coins = await getCoins();
    for (var i = 0; i < coins.coins.length; i++) {
      for (var j = 0; j < coins.coins[i].accounts.length; j++) {
        if (coins.coins[i].accounts[j].isSelect) {
          return [coins.coins[i].name, i];
        }
      }
    }
    return null;
  }
}
