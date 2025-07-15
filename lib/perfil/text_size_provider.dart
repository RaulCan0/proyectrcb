import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum TextSizeOption { ch, m, g }

class TextSizeProvider with ChangeNotifier {
  TextSizeOption _option = TextSizeOption.m;
  TextSizeOption get option => _option;

  TextSizeProvider() {
    _loadOption();
  }

  double get fontSize {
    switch (_option) {
      case TextSizeOption.ch:
        return 15.0;
      case TextSizeOption.m:
        return 16.0;
      case TextSizeOption.g:
        return 17.0;
    }
  }

  Future<void> _loadOption() async {
    final prefs = await SharedPreferences.getInstance();
    final idx = prefs.getInt('lensys_text_size') ?? 1;
    _option = TextSizeOption.values[idx];
    notifyListeners();
  }

  Future<void> setOption(TextSizeOption newOption) async {
    _option = newOption;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lensys_text_size', newOption.index);
  }

  void update(TextSizeOption newOption) {
    setOption(newOption);
  }
}
