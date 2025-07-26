import 'package:app_consulta_cotacoes/Quotes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('Validação do processamento de cotações', () {
    final Map<String, dynamic> mockValidation = {
      "time_last_update_utc": "Thu, 24 Jul 2025 00:00:01 +0000",
      "time_next_update_utc": "Fri, 25 Jul 2025 00:00:01 +0000",
      "base_code": "USD",
      "conversion_rates": {
        "USD": 1.0,
        "AED": 3.6725,
        "BRL": 5.5662,
        "EUR": 0.8506,
        "JPY": 150.78,
      },
    };

    final quotes = Quotes.fromJson(mockValidation);
    test('Validação da formatação de data e hora', () {

      final DateFormat apiDateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z");
      final DateTime dateTimeNextUpdade = apiDateFormat.parse("Fri, 25 Jul 2025 00:00:01 +0000");
      final DateTime dateTimeLastUpdate = apiDateFormat.parse("Thu, 24 Jul 2025 00:00:01 +0000");

      expect(quotes.nextTimeUpdate, dateTimeNextUpdade);
      expect(quotes.lastTimeUpdate, dateTimeLastUpdate);
    });
    test('Validação do array das conversões de cotações', () {
      expect(quotes.quotasData.length, 5);
      expect(quotes.quotasData['BRL'], isA<double>());
    });
    test('Validação da recuperação do cotação base', () {
      expect(quotes.baseQuote, 'USD');
    });
  });
}
