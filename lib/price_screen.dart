import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList.first;
  Map<String, String> coinRates =
      Map.fromIterable(cryptoList, key: (item) => item, value: (item) => '?');

  @override
  void initState() {
    super.initState();
    fetchCoinData(currency: selectedCurrency);
  }



  void fetchCoinData({String currency}) async {
    Map<String, String> tempCoinRates = Map();
    await Future.forEach(cryptoList, (crypto) async {
      var coinData = await CoinData()
          .getCoinData(coin: crypto, currency: selectedCurrency);
      var rate = coinData.rate == null ? '?' : coinData.rate.toStringAsFixed(2);
      tempCoinRates[crypto] = '$rate';
    });
    setState(() {
      coinRates = tempCoinRates;
    });
  }

  void updateCurrency(String currency) {
    setState(() {
      selectedCurrency = currency;
      coinRates.forEach((key, value) {
        coinRates[key] = '?';
      });
    });
    fetchCoinData(currency: selectedCurrency);
  }

  DropdownButton<String> getAndroidDropdown() {
    return DropdownButton<String>(
      items: currenciesList
          .map(
            (currency) => DropdownMenuItem(
              child: Text(currency),
              value: currency,
            ),
          )
          .toList(),
      value: selectedCurrency,
      onChanged: (newValue) {
        updateCurrency(newValue);
      },
    );
  }

  CupertinoPicker getiOSDropdown() {
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        updateCurrency(currenciesList[selectedIndex]);
      },
      children: currenciesList
          .map(
            (currency) => Text(currency),
          )
          .toList(),
    );
  }

  List<Widget> getCoinTrackers() {
    return cryptoList
        .map(
          (crypto) => Padding(
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
                  '1 $crypto = ${coinRates[crypto]} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        )
        .cast<Widget>()
        .toList();
  }

  Widget getSelectorContainer() {
    return Container(
        height: 150.0,
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 30.0),
        color: Colors.lightBlue,
        child: Platform.isIOS ? getiOSDropdown() : getAndroidDropdown());
  }

  List<Widget> getTrackersAndSelector() {
    List<Widget> widgetList = getCoinTrackers();
    widgetList.add(getSelectorContainer());
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('🤑 Coin Ticker'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: getTrackersAndSelector(),
        ));
  }
}
