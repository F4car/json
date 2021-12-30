import 'dart:convert';

import 'package:crypto_money/model/crypto_model.dart';
import 'package:flutter/material.dart';

class LocalJson extends StatefulWidget {
  const LocalJson({Key? key}) : super(key: key);

  @override
  State<LocalJson> createState() => _LocalJsonState();
}

class _LocalJsonState extends State<LocalJson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Json'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            jsonOku();
          });
        },
        child: const Icon(Icons.refresh),
      ),
      body: FutureBuilder<List<CryptoModel>>(
        future: jsonOku(),
        //veri gelmediyse ekranda eski verileri yada başka bişey göstermeye yarar.
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: 1, //snapshot.data!.length,
                itemBuilder: (context, index) {
                  var gelenData = snapshot.data!;
                  return ListTile(
                    leading: const Text('leading'),
                    trailing: const Text('trailing'),
                    title: Text(gelenData[2].symbol),
                    subtitle: Text(gelenData[2].price),
                  );
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<CryptoModel>> jsonOku() async {
    try {
      /*  await Future.delayed(Duration(seconds: 3), () {
        return Future.error('Zaman aşımı oluştu.');
      }); */
      await Future.delayed(const Duration(seconds: 2), () {
        debugPrint('bekleme');
        return const CircularProgressIndicator();
      });
      String okunanString = await DefaultAssetBundle.of(context)
          .loadString('assets/data/local.json');
      var jsonArray = jsonDecode(okunanString);

      List<CryptoModel> tumListe =
          (jsonArray as List).map((e) => CryptoModel.fromMap(e)).toList();

      return tumListe;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
