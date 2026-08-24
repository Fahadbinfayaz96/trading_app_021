import '../models/stock_model.dart';
import '../services/market_data_service.dart';

abstract class MarketRepository {
  Stream<Map<String, StockModel>> get priceStream;
  Map<String, StockModel> get currentPrices;
  StockModel? getStock(String symbol);
}

class MarketRepositoryImpl implements MarketRepository {
  final MarketDataService _service;

  MarketRepositoryImpl(this._service);

  @override
  Stream<Map<String, StockModel>> get priceStream => _service.stream;

  @override
  Map<String, StockModel> get currentPrices => _service.currentStocks;

  @override
  StockModel? getStock(String symbol) => _service.currentStocks[symbol];
}
