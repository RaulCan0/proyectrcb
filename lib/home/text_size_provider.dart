import 'package:flutter/material.dart';

enum TextSizeOption { ch, m, g }

class TextSizeProvider extends ChangeNotifier {
  TextSizeOption _option = TextSizeOption.m;

  double get fontSize {
    switch (_option) {
      case TextSizeOption.ch:
        return 12.0;
      case TextSizeOption.m:
        return 14.0;
      case TextSizeOption.g:
        return 16.0;
    }
  }

  TextSizeOption get option => _option;

  void setOption(TextSizeOption option) {
    _option = option;
    notifyListeners();
  }
}
