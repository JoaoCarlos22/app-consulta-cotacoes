import 'package:flutter/cupertino.dart';
import './Quotes.dart';

class QuotesProvider extends ChangeNotifier {
  Quotes? _quotesData;
  Quotes? get quotesData => _quotesData;

  // função que atualiza as cotas
  void setQuotes(Quotes newQuotes) {
    _quotesData = newQuotes;
    notifyListeners();
  }
}