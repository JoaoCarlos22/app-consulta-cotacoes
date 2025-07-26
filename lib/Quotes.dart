import 'package:intl/intl.dart';

class Quotes {
  final String lastTimeUpdate;
  final String nextTimeUpdate;
  final String baseQuote;
  final Map<String, double> quotasData;

  // construtor
  const Quotes({required this.lastTimeUpdate, required this.nextTimeUpdate, required this.baseQuote, required this.quotasData});

  // conversao dos dados
  factory Quotes.fromJson(Map<String, dynamic> json) {
    // formatacao da data e hora
    final DateFormat apiDateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z");
    final DateTime dateTimeNextUpdade = apiDateFormat.parse(json['time_next_update_utc'] as String);
    final DateTime dateTimeLastUpdate = apiDateFormat.parse(json['time_last_update_utc'] as String);

    // Formate as datas para exibição
    String formattedLastTimeUpdate = DateFormat('dd \'de\' MMMM \'de\' yyyy - HH:mm', 'pt_BR')
        .format(dateTimeLastUpdate.toLocal()) ;
    String formattedNextTimeUpdate = DateFormat('dd \'de\' MMMM \'de\' yyyy - HH:mm', 'pt_BR')
        .format(dateTimeNextUpdade.toLocal());

    // formatacao das cotações e seus valores
    Map<String, double> conversionRates = {};
    if (json['conversion_rates'] != null) {
      (json['conversion_rates'] as Map<String, dynamic>).forEach((key, value) {
        conversionRates[key] = (value as num).toDouble();
      });
    }

    // retorna o objeto com os valores formatados
    return Quotes(
        lastTimeUpdate: formattedLastTimeUpdate,
        nextTimeUpdate: formattedNextTimeUpdate,
        baseQuote: json['base_code'] as String,
        quotasData: conversionRates);
  }

}