import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import './Quotes.dart';
import 'QuotesProvider.dart';

class Details extends StatelessWidget {

  final String keyQuote;
  final double valueQuote;

  const Details({super.key, required this.keyQuote, required this.valueQuote});

  @override
  Widget build(BuildContext context) {
    final QuotesProvider quotesProvider =
    Provider.of<QuotesProvider>(context);
    final Quotes? quotes = quotesProvider.quotesData;

    if (quotes != null) {
      // Formate as datas para exibição
      String formattedLastTimeUpdate = DateFormat('dd \'de\' MMMM \'de\' yyyy - HH:mm', 'pt_BR')
          .format(quotes.lastTimeUpdate.toLocal()) ;
      String formattedNextTimeUpdate = DateFormat('dd \'de\' MMMM \'de\' yyyy - HH:mm', 'pt_BR')
          .format(quotes.nextTimeUpdate.toLocal());

      return Scaffold(
        appBar: AppBar(title: Text('Detalhes - Cotação ${keyQuote}')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Cotação financeira: $keyQuote"),
              Text('Valor: ${valueQuote.toStringAsFixed(4)}'),
              Text('Última atualização: $formattedLastTimeUpdate'),
              Text('Próxima atualização: $formattedNextTimeUpdate'),
            ],
          ),
        ),
      );
    }
    return const Text('Erro ao mostrar os detalhes da cotação!');
  }
}