import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burger/app/models/product_model.dart';
import 'package:vakinha_burger/app/pages/home/widgets/delivery_products_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppbar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return DeliveryProductsTile(
                  productModel: ProductModel(
                      id: 0,
                      name: 'X-Salada',
                      description:
                          'Lanche acompanha pão, hambúguer, mussarela, alface, tomate e maionese',
                      price: 15,
                      image:
                          'https://assets.unileversolutions.com/recipes-v2/106684.jpg?imwidth=800'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
