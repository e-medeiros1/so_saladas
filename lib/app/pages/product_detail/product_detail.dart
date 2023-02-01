// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_burger/app/core/extensions/formatter_extensions.dart';
import 'package:vakinha_burger/app/core/ui/helpers/size_extensions.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_increment_decrement_button.dart';
import 'package:vakinha_burger/app/dto/order_product_dto.dart';
import 'package:vakinha_burger/app/models/product_model.dart';
import 'package:vakinha_burger/app/pages/product_detail/product_detail_controller.dart';

import '../../core/ui/base_state/base_state.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel products;
  final OrderProductDto? productDto;
  const ProductDetail({
    Key? key,
    required this.products,
    required this.productDto,
  }) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState
    extends BaseState<ProductDetail, ProductDetailController> {
  @override
  void initState() {
    super.initState();
    final amount = widget.productDto?.amount ?? 1;
    controller.initial(amount, widget.productDto != null);
  }

  void _showConfirmDelete(int amount) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Deseja excluir o produto?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: context.textStyles.textBold.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pop(
                  OrderProductDto(
                      productModel: widget.products, amount: amount),
                );
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
    return Scaffold(
      appBar: DeliveryAppbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.screenWidth,
            height: context.percentHeight(.4),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.products.image),
                  fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.products.name,
              style: context.textStyles.textExtraBold.copyWith(fontSize: 22),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Text(
                  widget.products.description,
                ),
              ),
            ),
          ),
          const Divider(),
          Row(
            children: [
              Container(
                  height: 68,
                  padding: const EdgeInsets.all(8),
                  width: context.percentWidth(.5),
                  child: BlocBuilder<ProductDetailController, int>(
                    builder: (context, amount) {
                      return DeliveryIncrementDecrementButton(
                        amount: amount,
                        incrementOnTap: () {
                          controller.increment();
                        },
                        decrementOnTap: () {
                          controller.decrement();
                        },
                      );
                    },
                  )),
              Container(
                width: context.percentWidth(.5),
                height: 68,
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<ProductDetailController, int>(
                  builder: (context, amount) {
                    return ElevatedButton(
                      style: amount == 0
                          ? ElevatedButton.styleFrom(
                              backgroundColor: Colors.red)
                          : null,
                      onPressed: () {
                        if (amount == 0) {
                          _showConfirmDelete(amount);
                        } else {
                          Navigator.of(context).pop(
                            OrderProductDto(
                                productModel: widget.products, amount: amount),
                          );
                        }
                      },
                      child: Visibility(
                        visible: amount > 0,
                        replacement: Text('Excluir produto',
                            style: context.textStyles.textExtraBold),
                        child: Row(
                          children: [
                            Text(
                              'Adicionar',
                              style: context.textStyles.textExtraBold
                                  .copyWith(fontSize: 13),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AutoSizeText(
                                (widget.products.price * amount).currencyPtBr,
                                maxFontSize: 13,
                                minFontSize: 6,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: context.textStyles.textExtraBold,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
