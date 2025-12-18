import 'package:app_consulta_cotacoes/models/quotes.dart';
import 'package:flutter/material.dart';

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


