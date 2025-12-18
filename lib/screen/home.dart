import 'package:app_consulta_cotacoes/components/card_base_quote.dart';
import 'package:app_consulta_cotacoes/components/card_quote_list.dart';
import 'package:app_consulta_cotacoes/models/quotes.dart';
import 'package:app_consulta_cotacoes/providers/QuotesProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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