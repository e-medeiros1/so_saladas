// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:match/match.dart';
import 'package:vakinha_burger/app/dto/order_product_dto.dart';
import 'package:vakinha_burger/app/models/payment_model.dart';

part 'order_state.g.dart';

@match
enum OrderStatus {
  initial,
  loading,
  loaded,
  updatedOrder,
  error,
  confirmRemoveProduct,
  emptyBag,
  success,
}

class OrderState extends Equatable {
  final OrderStatus status;
  final List<OrderProductDto> productsDto;
  final List<PaymentModel> paymentTypes;
  final String? errorMessage;
  const OrderState({
    required this.status,
    required this.productsDto,
    required this.paymentTypes,
    this.errorMessage,
  });
  OrderState.initial()
      : status = OrderStatus.initial,
        errorMessage = null,
        productsDto = [],
        paymentTypes = [];

  double get totalOrder => productsDto.fold(
      0.0, (previousValue, element) => previousValue + element.totalPrice);

  @override
  List<Object?> get props => [status, productsDto, paymentTypes, errorMessage];

  OrderState copyWith({
    OrderStatus? status,
    List<OrderProductDto>? productsDto,
    List<PaymentModel>? paymentTypes,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      productsDto: productsDto ?? this.productsDto,
      paymentTypes: paymentTypes ?? this.paymentTypes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OrderConfirmDeleteProductState extends OrderState {
  final OrderProductDto orderProduct;
  final int index;

  const OrderConfirmDeleteProductState({
    required this.orderProduct,
    required this.index,
    required super.status,
    required super.productsDto,
    required super.paymentTypes,
    super.errorMessage,
  });
}
