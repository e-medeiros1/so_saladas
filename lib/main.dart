import 'package:flutter/cupertino.dart';
import 'package:vakinha_burger/app/vakinha_burger.dart';

import 'app/core/config/env.dart';

void main(List<String> args) async {
  await Env.instance.load();
  runApp(const VakinhaBurger());
}
