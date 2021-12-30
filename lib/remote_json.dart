import 'dart:async';
import 'package:crypto_money/model/crypto_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RemoteJson extends StatefulWidget {
  const RemoteJson({Key? key}) : super(key: key);

  @override
  _RemoteJsonState createState() => _RemoteJsonState();
}

class _RemoteJsonState extends State<RemoteJson> {
  Future<List<CryptoModel>> _future() async {
    try {
      var response =
          await Dio().get('https://api.binance.com/api/v3/ticker/price');
      List<CryptoModel> _cryptoList = [];
      if (response.statusCode == 200) {
        _cryptoList =
            (response.data as List).map((e) => CryptoModel.fromMap(e)).toList();
      }

      return _cryptoList;
    } on DioError catch (e) {
      return Future.error(e.message);
    }
  }

  late Timer _timer;
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _future();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Json'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () => setState(() {
          _startTimer();
        }),
      ),
      body: Center(
        child: FutureBuilder<List<CryptoModel>>(
            future: _future(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: 12, //snapshot.data!.length,
                    itemBuilder: (context, index) {
//********************************************************************************* */
                      List<double> liste = List.filled(2, 0, growable: true);
                      liste.add(double.parse(snapshot.data![11].price));

                      print(liste);

//********************************************************************************* */

                      return ListTile(
                        title: Text(snapshot.data![index].symbol),
                        subtitle: Text(snapshot.data![index].price),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
