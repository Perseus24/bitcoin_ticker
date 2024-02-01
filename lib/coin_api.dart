import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/networking.dart';
import 'package:flutter/material.dart';


class CoinAPI{

  Future<dynamic> getExchangeRate(String crypto, String currency) async{
    NetworkHelper networkHelper = NetworkHelper('$kUrl/$crypto/$currency?apikey=$kAPIkey');
    var coinData = await networkHelper.getData();
    if(coinData!=null){
      return coinData;
    }

  }
}