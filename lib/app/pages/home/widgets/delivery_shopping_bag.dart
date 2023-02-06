// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakinha_burger/app/core/extensions/formatter_extensions.dart';
import 'package:vakinha_burger/app/core/ui/helpers/size_extensions.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/dto/order_product_dto.dart';

import '../home_controller.dart';

class DeliveryShoppingBag extends StatelessWidget {
  final List<OrderProductDto> bag;
  const DeliveryShoppingBag({
    Key? key,
    required this.bag,
  }) : super(key: key);

  Future<void> _goOrder(BuildContext context) async {
    final controller = context.read<HomeController>();

    final navigator = Navigator.of(context);
    final sp = await SharedPreferences.getInstance();
    if (!sp.containsKey('accessToken')) {
      final loginResult = await navigator.pushNamed('/auth/login');
      if (loginResult == null || loginResult == false) return;
    }
    final updatedBag = await navigator.pushNamed('/order', arguments: bag);
    controller.updateBag(updatedBag as List<OrderProductDto>);
  }

  @override
  Widget build(BuildContext context) {
    final totalBag = bag
        .fold(0.0, (total, element) => total += element.totalPrice)
        .currencyPtBr;

    return Container(
      padding: const EdgeInsets.all(18),
      width: context.screenWidth,
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFFEDFFDE),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: ElevatedButton(
        onPressed: () {
          _goOrder(context);
        },
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.shopping_cart_outlined),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Ver sacola',
                style: context.textStyles.textExtraBold
                    .copyWith(color: Colors.white, fontSize: 14),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                totalBag,
                style: context.textStyles.textExtraBold
                    .copyWith(color: Colors.white, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
