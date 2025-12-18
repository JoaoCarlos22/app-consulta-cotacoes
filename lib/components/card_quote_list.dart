import 'package:app_consulta_cotacoes/screen/details.dart';
import 'package:flutter/material.dart';

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