import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/networking.dart';
import 'package:flutter/material.dart';


class CoinAPI{

  CoinAPI(this.crypto, this.currency);
  String crypto;
  String currency;

  Future<dynamic> getExchangeRate() async{
    NetworkHelper networkHelper = NetworkHelper('$kUrl/$crypto/$currency?apikey=$kAPIkey');

    var coinData = await networkHelper.getData();

    return coinData;

  }
}