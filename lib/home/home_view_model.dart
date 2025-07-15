import 'package:flutter/material.dart';
import 'package:lensysapp/home/home_user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeUserService _service = HomeUserService();
  final ScrollController scrollController = ScrollController();

  int selectedIndex = 1;
  Map<String, dynamic> userData = {};

  Future<void> signOut(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/loader');
  }

  Future<void> loadUserData() async {
    userData = await _service.getUserData();
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void scrollLeft() {
    final newOffset = (scrollController.offset - 200).clamp(
      0.0,
      scrollController.position.maxScrollExtent,
    );
    scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void scrollRight() {
    final newOffset = (scrollController.offset + 200).clamp(
      0.0,
      scrollController.position.maxScrollExtent,
    );
    scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
}
