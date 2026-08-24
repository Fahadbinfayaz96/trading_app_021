import 'package:equatable/equatable.dart';
import '../../../data/models/stock_model.dart';

class MarketState extends Equatable {
  final Map<String, StockModel> stocks;
  final bool isRunning;

  const MarketState({this.stocks = const {}, this.isRunning = false});

  MarketState copyWith({Map<String, StockModel>? stocks, bool? isRunning}) {
    return MarketState(
      stocks: stocks ?? this.stocks,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  @override
  List<Object?> get props => [stocks, isRunning];
}
