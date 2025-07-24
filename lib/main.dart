import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './Quotes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('teste app'),
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
                        return ListTile(
                          title: Text('$key : ${value.toStringAsFixed(4)}'),
                        );
                      }
                  );
                }
                return const CircularProgressIndicator();
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
