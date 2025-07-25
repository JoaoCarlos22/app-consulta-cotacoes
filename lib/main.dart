import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './Quotes.dart';
import './Details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Cotações Financeiras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('App de Cotações Financeiras'),
          ),
          body: FutureBuilder<Quotes>(
              future: fetchQuotes(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Erro ao mostrar os dados: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final Quotes quotes = snapshot.data!;
                  return  ListView.builder(
                      itemCount: quotes.quotasData.length,
                      itemBuilder: (context, index) {
                        String key = quotes.quotasData.keys.elementAt(index);
                        double value = quotes.quotasData.values.elementAt(
                            index);
                        return Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.from(alpha: 75, red: 161, green: 161, blue: 161),
                                width: 0.8,
                              ),
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                            //width: 50,
                            //color:Colors.amber,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('$key'),
                                Text('${value.toStringAsFixed(2)}'),
                                ElevatedButton(child: Text('Ver'),
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Details()),
                                    );
                                  }, )
                              ],
                            )
                        );
                        // return ListTile(
                        //   title: Text( : ${value.toStringAsFixed(4)}'),
                        // );
                      }
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
          )
      ),
    );
  }
}

Future<Quotes> fetchQuotes() async {
  try {
    final response = await http.get(
      Uri.parse('https://v6.exchangerate-api.com/v6/c484663a1f90675078cd7ba5/latest/USD'),
    );
    //debugPrint('API Response Body: ${response.body}');
    final Map<String, dynamic> jsonMap = jsonDecode(response.body);
    return Quotes.fromJson(jsonMap);
  } catch (e) {
    throw Exception('Falha ao carregar as cotas financeiras! - $e');
  }
}
