import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/stock_model.dart';
import '../../../data/repositories/market_repository.dart';
import 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  final MarketRepository _marketRepository;
  StreamSubscription? _sub;

  MarketCubit(this._marketRepository) : super(const MarketState());

  void startFeed({Duration? tickRate}) {
    _sub?.cancel();
    emit(state.copyWith(isRunning: true));
    _sub = _marketRepository.priceStream.listen((stocks) {
      emit(state.copyWith(stocks: stocks));
    });
  }

  void stopFeed() {
    _sub?.cancel();
    emit(state.copyWith(isRunning: false));
  }

  StockModel? getStock(String symbol) => state.stocks[symbol];

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
