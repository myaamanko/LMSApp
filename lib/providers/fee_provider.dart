import 'package:flutter/foundation.dart';

enum PaymentOption { full, half, term }

class FeeProvider with ChangeNotifier {
  PaymentOption _selectedOption = PaymentOption.full;

  PaymentOption get selectedOption => _selectedOption;

  void setOption(PaymentOption? option) {
    if (option != null) {
      _selectedOption = option;
      notifyListeners();
    }
  }
}
