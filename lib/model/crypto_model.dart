// To parse this JSON data, do
//
//     final cryptoModel = cryptoModelFromMap(jsonString);

import 'dart:convert';

List<CryptoModel> cryptoModelFromMap(String str) =>
    List<CryptoModel>.from(json.decode(str).map((x) => CryptoModel.fromMap(x)));

String cryptoModelToMap(List<CryptoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class CryptoModel {
  CryptoModel({
    required this.symbol,
    required this.price,
  });

  final String symbol;
  final String price;

  factory CryptoModel.fromMap(Map<String, dynamic> json) => CryptoModel(
        symbol: json["symbol"],
        price: json["price"],
      );

  Map<String, dynamic> toMap() => {
        "symbol": symbol,
        "price": price,
      };
}
