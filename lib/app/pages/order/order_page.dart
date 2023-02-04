import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_burger/app/dto/order_product_dto.dart';
import 'package:vakinha_burger/app/models/product_model.dart';
import 'package:vakinha_burger/app/pages/order/widget/order_field.dart';
import 'package:vakinha_burger/app/pages/order/widget/order_product_tile.dart';
import 'package:vakinha_burger/app/pages/order/widget/payment_types_field.dart';
import 'package:validatorless/validatorless.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final addressEC = TextEditingController();
  final cpfEC = TextEditingController();

  @override
  void dispose() {
    addressEC.dispose();
    cpfEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: DeliveryAppbar(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text('Carrinho',
                        style: context.textStyles.textTitle.copyWith()),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset('assets/images/trashRegular.png'),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 2,
                (context, index) {
                  return Column(
                    children: [
                      OrderProductTile(
                        index: index,
                        orderProduct: OrderProductDto(
                            productModel: ProductModel.fromMap({}), amount: 10),
                      ),
                      const Divider(
                        color: Colors.grey,
                      )
                    ],
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total do pedido',
                            style: context.textStyles.textExtraBold
                                .copyWith(fontSize: 16)),
                        Text(r'R$ 200,00',
                            style: context.textStyles.textExtraBold
                                .copyWith(fontSize: 20)),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  OrderField(
                    title: 'Endereço de entrega',
                    controller: addressEC,
                    hintText: 'Digite um endereço',
                    validator: Validatorless.required('Endereço obrigatório'),
                  ),
                  const SizedBox(height: 10),
                  OrderField(
                    title: 'CPF',
                    controller: addressEC,
                    hintText: 'Digite o CPF',
                    validator: Validatorless.required('CPF obrigatório'),
                  ),
                  const PaymentTypesField(),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Divider(
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: DeliveryButton(
                      width: double.infinity,
                      height: 48,
                      label: 'FINALIZAR',
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
