import 'dart:convert';
import 'package:http/http.dart' as http;

import './base_crypro_repository.dart';
import '../models/coin_model.dart';

class CryptoRepository extends BaseCryptoRepository {
  static const String _baseUrl = 'https://min-api.cryptocompare.com';
  static const int perPage = 20;

  final http.Client _httpClient;

  CryptoRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<List<Coin>> getTopCoins({int page}) async {
    List<Coin> coins = [];

    String requestUrl =
        '$_baseUrl/data/top/totalvolfull?limit=$perPage&tsym=USD&page=$page';

    try {
      final response = await http.get(requestUrl);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> coinList = data['Data'];

        coinList.forEach((element) {
          coins.add(Coin.fromJson(element));
        });

        return coins;
      }
    } catch (err) {
      throw (err);
    }

    return null;
  }

  @override
  void dispose() {
    _httpClient.close();
  }
}
