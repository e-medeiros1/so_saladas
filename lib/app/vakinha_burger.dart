import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/ui/theme/theme_config.dart';
import 'package:vakinha_burger/app/pages/splash/splash_page.dart';

class VakinhaBurger extends StatelessWidget {
  const VakinhaBurger({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vakinha Burger',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.theme,
      routes: {
        '/': (context) => const SplashPage(),
      },
    );
  }
}
