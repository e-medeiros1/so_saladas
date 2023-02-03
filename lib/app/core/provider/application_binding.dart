// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vakinha_burger/app/repositories/auth/auth_repository.dart';
import 'package:vakinha_burger/app/repositories/auth/auth_repository_impl.dart';

import '../rest_client/custom_dio.dart';

class ApplicationBinding extends StatelessWidget {
  final Widget child;
  const ApplicationBinding({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => CustomDio()),
        Provider<AuthRepository>(create: (context) => AuthRepositoryImpl(dio: context.read())),
      ],
      child: child,
    );
  }
}
