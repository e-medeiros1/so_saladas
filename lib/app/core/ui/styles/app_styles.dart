import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/ui/styles/colors_app.dart';

class AppStyles {
  static AppStyles? _instance;
  AppStyles._();

  static AppStyles get instance {
    _instance ??= AppStyles._();
    return _instance!;
  }

  ButtonStyle get primaryButton => ElevatedButton.styleFrom(
        backgroundColor: ColorsApp.instance.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      );
}

extension AppStylesExtension on BuildContext {
  AppStyles get appStyles => AppStyles.instance; 
}
