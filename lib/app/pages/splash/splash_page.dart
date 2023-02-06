import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/ui/helpers/size_extensions.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: const Color(0xFFEDFFDE),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: context.screenWidth,
                child: Image.asset(
                  'assets/images/logo_rounded.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: context.percentHeight(.16),
                  ),
                  Image.asset('assets/images/logo.png',
                      width: context.screenWidth,
                      color: const Color(0xFF61d800)),
                  SizedBox(
                    height: context.percentHeight(.36),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DeliveryButton(
                      width: context.percentWidth(.8),
                      height: 45,
                      label: 'Acessar',
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed('/home');
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
