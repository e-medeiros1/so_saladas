// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:vakinha_burger/app/dto/order_dto.dart';
import 'package:vakinha_burger/app/dto/order_product_dto.dart';
import 'package:vakinha_burger/app/pages/order/order_state.dart';
import 'package:vakinha_burger/app/repositories/order/order_repository.dart';

class OrderController extends Cubit<OrderState> {
  final OrderRepository _orderRepository;
  OrderController(
    this._orderRepository,
  ) : super(OrderState.initial());

  Future<void> load(List<OrderProductDto> products) async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));

      final paymentTypes = await _orderRepository.getAllPaymentsType();

      emit(state.copyWith(
          productsDto: products,
          paymentTypes: paymentTypes,
          status: OrderStatus.loaded));
    } catch (e, s) {
      log('Erro ao carregar página', error: e, stackTrace: s);
      emit(state.copyWith(
          status: OrderStatus.error, errorMessage: 'Erro ao carregar página'));
    }
  }

  void incrementProduct(int index) {
    //Para atualizar o estado é preciso duplicar a lista, caso contrário
    //o BloC não indentifica e não atualiza a tela
    final orderDto = [...state.productsDto];
    final order = orderDto[index];

    orderDto[index] = order.copyWith(amount: order.amount + 1);
    emit(state.copyWith(
        productsDto: orderDto, status: OrderStatus.updatedOrder));
  }

  void decrementProduct(int index) {
    final orderDto = [...state.productsDto];
    final order = orderDto[index];
    final amount = order.amount;

    if (amount == 1) {
      if (state.status != OrderStatus.confirmRemoveProduct) {
        emit(OrderConfirmDeleteProductState(
          orderProduct: order,
          index: index,
          status: OrderStatus.confirmRemoveProduct,
          productsDto: state.productsDto,
          paymentTypes: state.paymentTypes,
          errorMessage: state.errorMessage,
        ));
        return;
      } else {
        orderDto.removeAt(index);
      }
    } else {
      orderDto[index] = order.copyWith(amount: order.amount - 1);
    }

    if (orderDto.isEmpty) {
      emit(state.copyWith(status: OrderStatus.emptyBag));
      return;
    }

    emit(state.copyWith(
        productsDto: orderDto, status: OrderStatus.updatedOrder));
  }

  void cancelDeleteProccess() {
    emit(state.copyWith(status: OrderStatus.loaded));
  }

  void emptyBag() {
    emit(state.copyWith(status: OrderStatus.emptyBag));
  }

  Future<void> saveOrder(
      {required String address,
      required String document,
      required int paymentMethodId}) async {
    emit(state.copyWith(status: OrderStatus.loading));
    await _orderRepository.saveOrder(OrderDto(
        products: state.productsDto,
        address: address,
        document: document,
        paymentMethodId: paymentMethodId));
    emit(state.copyWith(status: OrderStatus.success));
  }
}
