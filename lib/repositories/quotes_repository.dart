import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Quotes.dart';

class QuotesRepository {
  Future<Quotes> fetchQuotes() async {
    final String urlApi = 'https://v6.exchangerate-api.com/v6/c484663a1f90675078cd7ba5/latest/USD';
    try {
      final response = await http.get(
        Uri.parse(urlApi),
      );
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return Quotes.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Falha ao carregar as cotas financeiras! - $e');
    }
  }
}