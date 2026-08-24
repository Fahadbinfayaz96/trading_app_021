import 'package:equatable/equatable.dart';
import '../../../data/models/order_model.dart';

class OrderState extends Equatable {
  final String symbol;
  final OrderSide side;
  final int quantity;
  final int? ltpPaise;
  final String? error;
  final bool isSubmitting;
  final bool isSuccess;

  const OrderState({
    required this.symbol,
    this.side = OrderSide.buy,
    this.quantity = 0,
    this.ltpPaise,
    this.error,
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  int get orderValuePaise => quantity * (ltpPaise ?? 0);

  OrderState copyWith({
    String? symbol,
    OrderSide? side,
    int? quantity,
    int? ltpPaise,
    String? error,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return OrderState(
      symbol: symbol ?? this.symbol,
      side: side ?? this.side,
      quantity: quantity ?? this.quantity,
      ltpPaise: ltpPaise ?? this.ltpPaise,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
    symbol,
    side,
    quantity,
    ltpPaise,
    error,
    isSubmitting,
    isSuccess,
  ];
}
