import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Warning with ChangeNotifier {
  WarningModel warningModel = WarningModel("", Colors.redAccent, false);


  void showWarning(String errorMassage, Color color, bool show) {
    warningModel = WarningModel(errorMassage, color, show);
    notifyListeners();
  }
}

class WarningModel {
  final String massage;
  final Color color;
  final bool show;

  WarningModel(this.massage, this.color, this.show);
}
