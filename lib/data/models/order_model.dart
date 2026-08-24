import 'package:equatable/equatable.dart';

enum OrderSide { buy, sell }

class OrderModel extends Equatable {
  final String id;
  final String symbol;
  final OrderSide side;
  final int quantity;
  final int pricePaise;
  final DateTime timestamp;

  const OrderModel({
    required this.id,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.pricePaise,
    required this.timestamp,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      side: OrderSide.values.byName(json['side'] as String),
      quantity: json['quantity'] as int,
      pricePaise: json['pricePaise'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'symbol': symbol,
    'side': side.name,
    'quantity': quantity,
    'pricePaise': pricePaise,
    'timestamp': timestamp.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    symbol,
    side,
    quantity,
    pricePaise,
    timestamp,
  ];
}
