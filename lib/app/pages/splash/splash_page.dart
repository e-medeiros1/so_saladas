import 'package:flutter/material.dart';

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
            TextFormField()
          ],
        ),
      ),
    );
  }
}
