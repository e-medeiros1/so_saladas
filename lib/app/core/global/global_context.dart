import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class GlobalContext {
  late final GlobalKey<NavigatorState> _navigatorKey;

  static GlobalContext? _instance;
  // Avoid self isntance
  GlobalContext._();
  static GlobalContext get instance {
    _instance ??= GlobalContext._();
    return _instance!;
  }

  set navigatorKey(GlobalKey<NavigatorState> key) => _navigatorKey = key;

  Future<void> loginExpired() async {
    final sp = await SharedPreferences.getInstance();
    sp.clear();
    showTopSnackBar(
      _navigatorKey.currentState!.overlay!,
      const CustomSnackBar.error(
          message:
              'Login expirado! Clique na sacola para uma nova autenticação'),
    );
    _navigatorKey.currentState!.popUntil(ModalRoute.withName('/home'));
  }
}
