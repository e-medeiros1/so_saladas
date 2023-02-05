import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_burger/app/core/extensions/formatter_extensions.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_burger/app/dto/order_product_dto.dart';
import 'package:vakinha_burger/app/models/payment_model.dart';
import 'package:vakinha_burger/app/pages/order/order_controller.dart';
import 'package:vakinha_burger/app/pages/order/widget/order_field.dart';
import 'package:vakinha_burger/app/pages/order/widget/order_product_tile.dart';
import 'package:vakinha_burger/app/pages/order/widget/payment_types_field.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/ui/base_state/base_state.dart';
import 'order_state.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final formKey = GlobalKey<FormState>();
  final addressEC = TextEditingController();
  final documentEC = TextEditingController();
  final paymentTypeValid = ValueNotifier<bool>(true);
  int? paymentTypeId;

  @override
  void onReady() {
    final products =
        ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;

    controller.load(products);
    super.onReady();
  }

  @override
  void dispose() {
    addressEC.dispose();
    documentEC.dispose();
    super.dispose();
  }

  void _showConfirmProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              'Deseja excluir o produto ${state.orderProduct.productModel.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.cancelDeleteProccess();
              },
              child: Text(
                'Cancelar',
                style: context.textStyles.textBold.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.decrementProduct(state.index);
              },
              child: Text(
                'Confirmar',
                style: context.textStyles.textBold,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<OrderController, OrderState>(
        listener: (context, state) {
          state.status.matchAny(
            any: () => hideLoader(),
            loading: showLoader,
            error: () {
              hideLoader();
              showError(state.errorMessage ?? 'Erro não informado');
            },
            confirmRemoveProduct: () {
              hideLoader();
              if (state is OrderConfirmDeleteProductState) {
                _showConfirmProductDialog(state);
              }
            },
            emptyBag: () {
              showInfo(
                  'Sua sacola está vazia! Selecione um produto para realizar seu pedido');
              Navigator.pop(context, <OrderProductDto>[]);
            },
            success: () {
              hideLoader();
              Navigator.of(context).popAndPushNamed('/order/completed',
                  result: <OrderProductDto>[]);
            },
          );
        },
        child: WillPopScope(
          //Usa conceitos de flutter para bloquear movimentação nativa do
          //android e executar uma função específica
          onWillPop: () async {
            Navigator.of(context).pop(controller.state.productsDto);
            return false;
          },
          child: Scaffold(
            appBar: DeliveryAppbar(),
            body: Form(
              key: formKey,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          Text('Carrinho',
                              style: context.textStyles.textTitle.copyWith()),
                          IconButton(
                            onPressed: () => controller.emptyBag(),
                            icon: Image.asset('assets/images/trashRegular.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocSelector<OrderController, OrderState,
                      List<OrderProductDto>>(
                    selector: (state) {
                      return state.productsDto;
                    },
                    builder: (context, orderProducts) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: orderProducts.length,
                          (context, index) {
                            final orderProd = orderProducts[index];
                            return Column(
                              children: [
                                OrderProductTile(
                                  index: index,
                                  orderProduct: orderProd,
                                ),
                                const Divider(
                                  color: Colors.grey,
                                )
                              ],
                            );
                          },
                        ),
                      );
                    },
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
                              BlocSelector<OrderController, OrderState, double>(
                                selector: (state) => state.totalOrder,
                                builder: (context, totalOrder) {
                                  return Text(
                                    totalOrder.currencyPtBr,
                                    style: context.textStyles.textExtraBold
                                        .copyWith(fontSize: 20),
                                  );
                                },
                              ),
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
                          validator:
                              Validatorless.required('Endereço obrigatório'),
                        ),
                        const SizedBox(height: 10),
                        OrderField(
                          title: 'CPF',
                          controller: documentEC,
                          hintText: 'Digite o CPF',
                          validator: Validatorless.required('CPF obrigatório'),
                        ),
                        const SizedBox(height: 10),
                        BlocSelector<OrderController, OrderState,
                            List<PaymentModel>>(
                          selector: (state) => state.paymentTypes,
                          builder: (context, payments) {
                            return ValueListenableBuilder(
                              valueListenable: paymentTypeValid,
                              builder: (_, paymentTypeValidValue, child) =>
                                  PaymentTypesField(
                                valueChanged: (value) {
                                  paymentTypeId = value;
                                },
                                paymentTypes: payments,
                                valueSelected: paymentTypeId.toString(),
                                valid: paymentTypeValidValue,
                              ),
                            );
                          },
                        ),
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
                            onPressed: () {
                              final valid =
                                  formKey.currentState?.validate() ?? false;
                              final paymentTypeSelected = paymentTypeId != null;
                              paymentTypeValid.value = paymentTypeSelected;
                              if (valid && paymentTypeSelected) {
                                controller.saveOrder(
                                  address: addressEC.text,
                                  document: documentEC.text,
                                  paymentMethodId: paymentTypeId!,
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
