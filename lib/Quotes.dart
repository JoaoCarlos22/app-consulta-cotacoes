class Quotes {
  final String lastTimeUpdate;
  final String nextTimeUpdate;
  final String baseQuote;
  final Map<String, double> quotasData;

  // construtor
  const Quotes({required this.lastTimeUpdate, required this.nextTimeUpdate, required this.baseQuote, required this.quotasData});

  // conversao dos dados
  factory Quotes.fromJson(Map<String, dynamic> json) {
    Map<String, double> conversionRates = {};
    if (json['conversion_rates'] != null) {
      (json['conversion_rates'] as Map<String, dynamic>).forEach((key, value) {
        conversionRates[key] = (value as num).toDouble();
      });
    }

    // retorna convertendo o resto
    return Quotes(
        lastTimeUpdate: json['time_last_update_utc'] as String,
        nextTimeUpdate: json['time_next_update_utc'] as String,
        baseQuote: json['base_code'] as String,
        quotasData: conversionRates);
  }

}