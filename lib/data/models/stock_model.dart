import 'package:equatable/equatable.dart';

class StockModel extends Equatable {
  final String symbol;
  final String name;
  final int ltpPaise;
  final int previousClosePaise;
  final int changePaise;

  const StockModel({
    required this.symbol,
    required this.name,
    required this.ltpPaise,
    required this.previousClosePaise,
    int? changePaise,
  }) : changePaise = changePaise ?? ltpPaise - previousClosePaise;

  double get changePercent =>
      previousClosePaise > 0 ? (changePaise / previousClosePaise) * 100 : 0.0;

  StockModel copyWith({
    String? symbol,
    String? name,
    int? ltpPaise,
    int? previousClosePaise,
    int? changePaise,
  }) {
    return StockModel(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      ltpPaise: ltpPaise ?? this.ltpPaise,
      previousClosePaise: previousClosePaise ?? this.previousClosePaise,
      changePaise: changePaise,
    );
  }

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      ltpPaise: json['ltpPaise'] as int,
      previousClosePaise: json['previousClosePaise'] as int,
      changePaise: json['changePaise'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'name': name,
    'ltpPaise': ltpPaise,
    'previousClosePaise': previousClosePaise,
    'changePaise': changePaise,
  };

  @override
  List<Object?> get props => [symbol, ltpPaise, changePaise];
}
