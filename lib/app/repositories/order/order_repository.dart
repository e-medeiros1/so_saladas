import 'package:vakinha_burger/app/dto/order_dto.dart';

import '../../models/payment_model.dart';

abstract class OrderRepository {
  Future<List<PaymentModel>> getAllPaymentsType();
  Future<void> saveOrder(OrderDto order);
}
