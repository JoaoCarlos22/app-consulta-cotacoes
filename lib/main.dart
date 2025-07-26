import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'models/Quotes.dart';
import './repositories/quotesRepository.dart';
import 'providers/QuotesProvider.dart';
import 'screen/Details.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => QuotesProvider(QuotesRepository()),
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
      supportedLocales: const [Locale('pt', 'BR')],
    );
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
    _quotesFuture = loadInitialQuotes();
  }

  Future<void> loadInitialQuotes() async {
    final quotesProvider = Provider.of<QuotesProvider>(context, listen: false);
    await quotesProvider.setQuotes();
  }

  Future<void> refresh() async {
    setState(() {
      _quotesFuture = loadInitialQuotes();
    });

    await _quotesFuture;
  }

  @override
  Widget build(BuildContext context) {
    final QuotesProvider quotesProvider = Provider.of<QuotesProvider>(context);
    final Quotes? currentQuotes = quotesProvider.quotesData;
    return MaterialApp(
      title: 'App de Cotações Financeiras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('App de Cotações Financeiras'),
          centerTitle: true,
          elevation: 50.0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: Center(
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
                    return const Text(
                      'Nenhum dado de cotação disponível após o fetch.',
                    );
                  }
                  return Column(
                    children: [
                      cardBaseQuote(context, currentQuotes),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 2.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sigla',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                            ),
                            Expanded(
                              child: Text(
                                'Valor',
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Divider(color: Colors.grey[300]),
                      const SizedBox(height: 4.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: currentQuotes.quotasData.length,
                          itemBuilder: (context, index) {
                            String? key = currentQuotes.quotasData.keys
                                .elementAt(index);
                            double? value = currentQuotes.quotasData.values
                                .elementAt(index);
                            return cardQuoteList(context, key, value);
                          },
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
      ),
    );
  }
}

Widget cardBaseQuote(BuildContext context, Quotes currentQuotes) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cotação Base',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentQuotes.baseQuote,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Icon(
                Icons.attach_money,
                color: Theme.of(context).primaryColor.withOpacity(0.7),
                size: 32,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget cardQuoteList(BuildContext context, String? key, double? value) {
  if (key != null && value != null) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Details(keyQuote: key, valueQuote: value),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                key,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  value.toStringAsFixed(2),
                  textAlign: TextAlign.right,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.grey[800]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  return const Text('Erro ao mostrar as cotações!');
}
