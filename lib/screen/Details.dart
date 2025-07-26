import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/Quotes.dart';
import '../providers/QuotesProvider.dart';

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
        appBar: AppBar(title: Text('Detalhes - Cotação ${keyQuote}'),
          elevation: 50.0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              cardQuote(context, keyQuote, valueQuote),
              const SizedBox(height: 24.0),
              cardUpdate(context, formattedLastTimeUpdate, formattedNextTimeUpdate)
          ],
        ),
      ),
      );
    }
    return const Text('Erro ao mostrar os detalhes da cotação!');
  }
}

Widget cardQuote(BuildContext context, String keyQuote, double valueQuote) {
  return Card(
    elevation: 6.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            keyQuote,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Valor: ${valueQuote.toStringAsFixed(4)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Cotação financeira',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );
}

Widget cardUpdate(BuildContext context, String formattedLastTimeUpdate, String formattedNextTimeUpdate) {
  return Card(
    elevation: 2.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informações de Atualização',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 16.0),

          Row(
            children: [
              Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 10.0),
              textUpdate(context, "Última", formattedLastTimeUpdate)
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 10.0),
              textUpdate(context, "Próxima", formattedNextTimeUpdate)
            ],
          ),
        ],
      ),
    ),
  );
}

Widget textUpdate(BuildContext context, String command, String dateTimeUpdate) {
  return Expanded(
    child: Text(
      '$command atualização: $dateTimeUpdate',
      style: Theme.of(context).textTheme.bodyLarge,
    ),
  );
}