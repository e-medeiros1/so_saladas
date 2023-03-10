// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vakinha_burger/app/core/extensions/formatter_extensions.dart';
import 'package:vakinha_burger/app/core/ui/styles/colors_app.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/dto/order_product_dto.dart';
import 'package:vakinha_burger/app/pages/home/home_controller.dart';

import '../../../models/product_model.dart';

class DeliveryProductsTile extends StatelessWidget {
  final ProductModel productModel;
  final OrderProductDto? orderProductDto;
  const DeliveryProductsTile({
    Key? key,
    required this.productModel,
    required this.orderProductDto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final controller = context.read<HomeController>();
        final orderProduct = await Navigator.of(context)
            .pushNamed('/product-detail', arguments: {
          'product': productModel,
          'order': orderProductDto,
        });
        if (orderProduct != null) {
          controller.addOrUpdateBag(orderProduct as OrderProductDto);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(productModel.name,
                        style: context.textStyles.textExtraBold
                            .copyWith(fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(productModel.description,
                        style: context.textStyles.textRegular
                            .copyWith(fontSize: 13)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      productModel.price.currencyPtBr,
                      style: context.textStyles.textMedium.copyWith(
                          fontSize: 18, color: context.colors.secondary),
                    ),
                  ),
                ],
              ),
            ),
            FadeInImage.assetNetwork(
              width: 100,
              height: 100,
              placeholder: 'assets/images/loading.gif',
              image: productModel.image,
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }
}
