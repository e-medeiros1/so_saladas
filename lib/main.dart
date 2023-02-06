import 'package:flutter/cupertino.dart';
import 'package:vakinha_burger/app/so_saladas.dart';

import 'app/core/config/env.dart';

void main(List<String> args) async {
  await Env.instance.load();
  runApp(SoSaladas());
}
