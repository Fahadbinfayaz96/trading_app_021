import '../models/holding_model.dart';
import '../services/local_storage_service.dart';

abstract class HoldingsRepository {
  Future<List<HoldingModel>> getHoldings();
  Future<void> saveHoldings(List<HoldingModel> holdings);
  Future<void> updateHolding(String symbol, int qty, int pricePaise);
  Future<void> reduceHolding(String symbol, int qty);
}

class HoldingsRepositoryImpl implements HoldingsRepository {
  final LocalStorageService _storage;

  HoldingsRepositoryImpl(this._storage);

  @override
  Future<List<HoldingModel>> getHoldings() async {
    final data = _storage.getHoldings();
    if (data == null) return [];
    return data.map((e) => HoldingModel.fromJson(e)).toList();
  }

  @override
  Future<void> saveHoldings(List<HoldingModel> holdings) async {
    await _storage.saveHoldings(holdings.map((e) => e.toJson()).toList());
  }

  @override
  Future<void> updateHolding(String symbol, int qty, int pricePaise) async {
    final holdings = await getHoldings();
    final index = holdings.indexWhere((h) => h.symbol == symbol);
    if (index >= 0) {
      final existing = holdings[index];
      final totalCost =
          (existing.quantity * existing.avgCostPaise) + (qty * pricePaise);
      final totalQty = existing.quantity + qty;
      holdings[index] = existing.copyWith(
        quantity: totalQty,
        avgCostPaise: totalCost ~/ totalQty,
      );
    } else {
      holdings.add(
        HoldingModel(symbol: symbol, quantity: qty, avgCostPaise: pricePaise),
      );
    }
    await saveHoldings(holdings);
  }

  @override
  Future<void> reduceHolding(String symbol, int qty) async {
    final holdings = await getHoldings();
    final index = holdings.indexWhere((h) => h.symbol == symbol);
    if (index >= 0) {
      final existing = holdings[index];
      final newQty = existing.quantity - qty;
      if (newQty <= 0) {
        holdings.removeAt(index);
      } else {
        holdings[index] = existing.copyWith(quantity: newQty);
      }
      await saveHoldings(holdings);
    }
  }
}
