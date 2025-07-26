import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import './Quotes.dart';
import './QuotesProvider.dart';
import './Details.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => QuotesProvider(),
      child: const MyApp(),
    ),
  );
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
      home: Home(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
    );
  }
}

Future<void> fetchQuotes(BuildContext context) async {
  try {
    final response = await http.get(
      Uri.parse(
        'https://v6.exchangerate-api.com/v6/c484663a1f90675078cd7ba5/latest/USD',
      ),
    );
    //debugPrint('API Response Body: ${response.body}');
    final Map<String, dynamic> jsonMap = jsonDecode(response.body);
    final Quotes quotes = Quotes.fromJson(jsonMap);

    Provider.of<QuotesProvider>(context, listen: false).setQuotes(quotes);
  } catch (e) {
    throw Exception('Falha ao carregar as cotas financeiras! - $e');
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => QuotesScreen();
}

class QuotesScreen extends State<Home> {
  late Future<void> _quotesFuture;

  @override
  void initState() {
    super.initState();
    _quotesFuture = fetchQuotes(context);
  }

  Future<void> refresh() async {
    setState(() {
      _quotesFuture = fetchQuotes(context);
    });

    await _quotesFuture;
  }

  @override
  Widget build(BuildContext context) {
    final QuotesProvider quotesProvider =
    Provider.of<QuotesProvider>(context);
    final Quotes? currentQuotes = quotesProvider.quotesData;
    return MaterialApp(
      title: 'App de Cotações Financeiras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('App de Cotações Financeiras')),
        body: Center(
          child: FutureBuilder<void>(
            future: _quotesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                if (currentQuotes == null) {
                  return const CircularProgressIndicator();
                }
              } else if (snapshot.hasError) {
                return Text('Erro ao mostrar os dados: ${snapshot.error}');
              } else {
                if (currentQuotes == null) {
                  return const Text('Nenhum dado de cotação disponível após o fetch.');
                }
                return Column(
                  children: [
                    Text('Cotação base: ${currentQuotes.baseQuote}'),
                    const SizedBox(height: 20),
                    Expanded(
                        child: RefreshIndicator(
                      onRefresh: refresh,
                        child: ListView.builder(
                          itemCount: currentQuotes.quotasData.length,
                          itemBuilder: (context, index) {
                            String? key = currentQuotes.quotasData.keys
                                .elementAt(index);
                            double? value = currentQuotes.quotasData.values
                                .elementAt(index);
                            return Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.from(
                                    alpha: 75,
                                    red: 161,
                                    green: 161,
                                    blue: 161,
                                  ),
                                  width: 0.8,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              //width: 50,
                              //color:Colors.amber,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('$key'),
                                  Text('${value.toStringAsFixed(2)}'),
                                  ElevatedButton(
                                    child: Text('Ver'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Details(
                                            keyQuote: key,
                                            valueQuote: value,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                            // return ListTile(
                            //   title: Text( : ${value.toStringAsFixed(4)}'),
                            // );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
