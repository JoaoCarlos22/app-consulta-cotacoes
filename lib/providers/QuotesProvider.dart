import 'package:flutter/cupertino.dart';
import '../models/quotes.dart';
import '../repositories/quotesRepository.dart';

class QuotesProvider extends ChangeNotifier {
  final QuotesRepository _quotesRepository;
  Quotes? _quotesData;

  Quotes? get quotesData => _quotesData;

  QuotesProvider(this._quotesRepository);

  // função que atualiza as cotas
  Future<void> setQuotes() async {
    final Quotes fetchedQuotes = await _quotesRepository.fetchQuotes();
    _quotesData = fetchedQuotes;
    notifyListeners();
  }
}
