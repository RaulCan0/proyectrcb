import 'package:flutter/material.dart';


enum TextSizeOption { ch, m, g }

class TextSizeProvider with ChangeNotifier {
  TextSizeOption _option = TextSizeOption.m;
  TextSizeOption get option => _option;

  double get fontSize {
    switch (_option) {
      case TextSizeOption.ch:
        return 14.0;
      case TextSizeOption.m:
        return 15.0;
      case TextSizeOption.g:
        return 16.0;
    }
  }

  void update(TextSizeOption newOption) {
    _option = newOption;
    notifyListeners();
  }
}
