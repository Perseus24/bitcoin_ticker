import 'package:bitcoin_ticker/coin_api.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/reusable_widget.dart';
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
  List<double> bitcoinRates = [];
  ContainerWidget containerWidget = ContainerWidget();
  List<Widget> containers = [];
  CoinAPI coinAPI = CoinAPI();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    displayContainers();

  }

  Future<List<double>> updateData() async{
    bitcoinRates.clear();
    for(String cryptos in cryptoList) {
      var data = await coinAPI.getExchangeRate(cryptos, currency);
      bitcoinRates.add(data['rate']);//added the rates from the three bitcoins to a list
    }
    return bitcoinRates;
  }
  //bitcoinRates.add(data['rate']);

  void displayContainers() async{
    containers.clear();
    bitcoinRates = await updateData();
    for(int i=0; i<3; i++){
      crypto = cryptoList[i];
      setState(() {
        containers.add(containerWidget.buildContainers(bitcoinRates.isEmpty?0:bitcoinRates[i], currency, crypto));
      });
    }
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
          (bitcoinRates.isEmpty)?
          Container(
              child: Center(child: CircularProgressIndicator())
          ):
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: containers,
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
          displayContainers();
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

