import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<CoinDto> getCoinData({String coin, String currency}) async {
    var url = Uri.parse('https://rest.coinapi.io/v1/exchangerate/$coin/$currency?apikey=29056CED-6778-4DE1-AED8-F7B80103D055');
    var response = await http.get(url);
    return CoinDto.fromJson(jsonDecode(response.body));
  }
}

class CoinDto {
  double rate;

  CoinDto({this.rate});

  factory CoinDto.fromJson(dynamic json) {
    return CoinDto(rate: json['rate']);
  }
}