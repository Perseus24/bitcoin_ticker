import 'package:bitcoin_ticker/coin_api.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String crypto = 'BTC';
  String currency = 'USD';
  double rate = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateData();
  }

  void updateData() async{
    CoinAPI coinAPI = CoinAPI(crypto, currency);
    var data = await coinAPI.getExchangeRate();
    setState(() {
      rate = data['rate'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ${NumberFormat("#,##0").format(rate)} $currency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getDropdownButton()
          ),
        ],
      ),
    );
  }

  DropdownButton<String> getDropdownButton(){
    List<DropdownMenuItem<String>> currencyList = [];

    currencyList = currenciesList.map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: TextStyle(
            fontSize: 14,
          ),
        )
    )).toList();

    return DropdownButton<String>(
      menuMaxHeight: 200,
      value: currency,
      items: currencyList,
      onChanged: (value){
        setState(() {
          currency = value!;
          updateData();
        });
      },
    );

  }

  CupertinoPicker getCupertinoTicker(){

    List<Widget> currencies = [];

    for(String cur in currenciesList){
      currencies.add(Text(cur));
    }

    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex){
        print(selectedIndex);
      },
      children: currencies,
    );
  }

  Widget getPicker(){
    if(Platform.isIOS){
      return getCupertinoTicker();
    }else if(Platform.isAndroid){
      return getDropdownButton();
    }
    return Container();

  }

}

