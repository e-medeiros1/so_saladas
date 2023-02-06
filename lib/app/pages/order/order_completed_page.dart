import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/ui/helpers/size_extensions.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_button.dart';

class OrderCompletedPage extends StatelessWidget {
  const OrderCompletedPage({super.key});

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
                  'assets/images/saladas-done.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: context.percentHeight(.15),
                  ),
                  Image.asset('assets/images/logo.png',
                      width: context.screenWidth,
                      color: const Color(0xFF61d800)),
                  SizedBox(
                    height: context.percentHeight(.36),
                  ),
                  Text(
                    'Pedido realizado com sucesso, aguarde a nossa confirmação e bom apetite!',
                    textAlign: TextAlign.center,
                    style:
                        context.textStyles.textExtraBold.copyWith(fontSize: 18),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: DeliveryButton(
                        width: context.percentWidth(.8),
                        label: 'FECHAR',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



//   }
// }