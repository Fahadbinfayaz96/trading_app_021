import 'package:equatable/equatable.dart';

class HoldingModel extends Equatable {
  final String symbol;
  final int quantity;
  final int avgCostPaise;

  const HoldingModel({
    required this.symbol,
    required this.quantity,
    required this.avgCostPaise,
  });

  int get currentValuePaise => quantity * avgCostPaise;

  HoldingModel copyWith({String? symbol, int? quantity, int? avgCostPaise}) {
    return HoldingModel(
      symbol: symbol ?? this.symbol,
      quantity: quantity ?? this.quantity,
      avgCostPaise: avgCostPaise ?? this.avgCostPaise,
    );
  }

  factory HoldingModel.fromJson(Map<String, dynamic> json) {
    return HoldingModel(
      symbol: json['symbol'] as String,
      quantity: json['quantity'] as int,
      avgCostPaise: json['avgCostPaise'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'quantity': quantity,
    'avgCostPaise': avgCostPaise,
  };

  @override
  List<Object?> get props => [symbol, quantity, avgCostPaise];
}
