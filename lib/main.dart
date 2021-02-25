import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=d81e39b4";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.black26,
        primaryColor: Colors.purple,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.purple[300])),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return (json.decode(response.body));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realcontroller = TextEditingController();
  final dolarcontroller = TextEditingController();
  final eurocontroller = TextEditingController();

  // variaveis que recebem dados da API
  double dolar;
  double euro;

  void _realClick(String text) {
    double real = double.parse(text);
    dolarcontroller.text = (real / dolar).toStringAsFixed(2);
    eurocontroller.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarClick(String text) {
    double dolartext = double.parse(text);
    realcontroller.text = (dolartext * dolar).toStringAsFixed(2);
    eurocontroller.text = (dolartext * dolar / euro).toStringAsFixed(2);
  }

  void _euroClick(String text) {
    double eurotext = double.parse(text);
    realcontroller.text = (eurotext * euro).toStringAsFixed(2);
    dolarcontroller.text = (eurotext * euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text("Conversor de moeda"),
            backgroundColor: Colors.purple,
            centerTitle: true),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Dados estão sendo carregados",
                    style: TextStyle(color: Colors.purple, fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Erro ao carregar os dados",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.purple),
                          Divider(),
                          createTextField(
                              "Real", "R\$", realcontroller, _realClick),
                          Divider(),
                          createTextField(
                              "Dolar", "US\$", dolarcontroller, _dolarClick),
                          Divider(),
                          createTextField(
                              "Euro", "€", eurocontroller, _euroClick),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget createTextField(String label, String prefix,
    TextEditingController controlador, Function click) {
  return TextField(
    controller: controlador,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.purple),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.black, fontSize: 25.0),
    keyboardType: TextInputType.number,
    onChanged: click,
  );
}
