import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_button.dart';

import '../../core/core/config/env.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Teste'),
            ElevatedButton(
              onPressed: () {},
              child: const Text('My elevated button'),
            ),
            TextFormField(),
            DeliveryButton(
              width: 200,
              height: 100,
              label: Env.instance['backend_base_url'] ?? '',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
