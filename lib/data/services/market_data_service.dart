import 'dart:async';
import 'dart:math';
import '../models/stock_model.dart';

class MarketDataService {
  static final MarketDataService _instance = MarketDataService._internal();
  factory MarketDataService() => _instance;
  MarketDataService._internal();

  final _controller = StreamController<Map<String, StockModel>>.broadcast();
  Timer? _timer;

  final Map<String, StockModel> _stocks = {
    'RELIANCE': const StockModel(
      symbol: 'RELIANCE',
      name: 'Reliance Industries',
      ltpPaise: 245050,
      previousClosePaise: 243000,
    ),
    'TCS': const StockModel(
      symbol: 'TCS',
      name: 'Tata Consultancy',
      ltpPaise: 325000,
      previousClosePaise: 323500,
    ),
    'INFY': const StockModel(
      symbol: 'INFY',
      name: 'Infosys',
      ltpPaise: 168000,
      previousClosePaise: 167200,
    ),
    'HDFCBANK': const StockModel(
      symbol: 'HDFCBANK',
      name: 'HDFC Bank',
      ltpPaise: 142500,
      previousClosePaise: 142000,
    ),
    'ICICIBANK': const StockModel(
      symbol: 'ICICIBANK',
      name: 'ICICI Bank',
      ltpPaise: 108000,
      previousClosePaise: 107500,
    ),
    'SBIN': const StockModel(
      symbol: 'SBIN',
      name: 'State Bank',
      ltpPaise: 62000,
      previousClosePaise: 61500,
    ),
    'ITC': const StockModel(
      symbol: 'ITC',
      name: 'ITC Limited',
      ltpPaise: 42500,
      previousClosePaise: 42100,
    ),
    'LT': const StockModel(
      symbol: 'LT',
      name: 'Larsen & Toubro',
      ltpPaise: 318000,
      previousClosePaise: 316500,
    ),
    'BHARTIARTL': const StockModel(
      symbol: 'BHARTIARTL',
      name: 'Bharti Airtel',
      ltpPaise: 112000,
      previousClosePaise: 111500,
    ),
    'AXISBANK': const StockModel(
      symbol: 'AXISBANK',
      name: 'Axis Bank',
      ltpPaise: 98000,
      previousClosePaise: 97500,
    ),
  };

  Stream<Map<String, StockModel>> get stream => _controller.stream;
  Map<String, StockModel> get currentStocks => Map.unmodifiable(_stocks);

  void start({Duration tickRate = const Duration(milliseconds: 600)}) {
    _timer?.cancel();
    _timer = Timer.periodic(tickRate, (_) {
      _tick();
      _controller.add(Map.unmodifiable(_stocks));
    });
  }

  void _tick() {
    final random = Random();
    for (final entry in _stocks.entries) {
      final stock = entry.value;
      final changePercent = (random.nextDouble() - 0.5) * 0.006;
      final change = (stock.ltpPaise * changePercent).round();
      final newLtp = stock.ltpPaise + change;
      if (newLtp > 0) {
        _stocks[stock.symbol] = stock.copyWith(
          ltpPaise: newLtp,
          changePaise: newLtp - stock.previousClosePaise,
        );
      }
    }
  }

  void stop() => _timer?.cancel();

  void dispose() {
    stop();
    _controller.close();
  }
}
