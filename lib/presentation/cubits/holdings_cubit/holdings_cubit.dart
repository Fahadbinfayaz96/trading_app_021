import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/holding_model.dart';
import '../../../data/repositories/holding_repository.dart';
import 'holdings_state.dart';

class HoldingsCubit extends Cubit<HoldingsState> {
  final HoldingsRepository _repository;

  HoldingsCubit(this._repository) : super(const HoldingsState());

  Future<void> load() async {
    final holdings = await _repository.getHoldings();
    emit(state.copyWith(holdings: holdings, isLoading: false));
  }

  void setSort(HoldingsSort sort) => emit(state.copyWith(sort: sort));

  List<HoldingModel> getSortedHoldings(Map<String, int> livePrices) {
    final list = List<HoldingModel>.from(state.holdings);
    switch (state.sort) {
      case HoldingsSort.symbol:
        list.sort((a, b) => a.symbol.compareTo(b.symbol));
        break;
      case HoldingsSort.valueDesc:
        list.sort((a, b) {
          final va = (livePrices[a.symbol] ?? 0) * b.quantity;
          final vb = (livePrices[b.symbol] ?? 0) * a.quantity;
          return vb.compareTo(va);
        });
        break;
      case HoldingsSort.pnlDesc:
      case HoldingsSort.pnlAsc:
        list.sort((a, b) {
          final pa = (livePrices[a.symbol] ?? a.avgCostPaise) - a.avgCostPaise;
          final pb = (livePrices[b.symbol] ?? b.avgCostPaise) - b.avgCostPaise;
          final cmp = pb.compareTo(pa);
          return state.sort == HoldingsSort.pnlAsc ? -cmp : cmp;
        });
        break;
    }
    return list;
  }

  Future<void> refresh() async {
    final holdings = await _repository.getHoldings();
    emit(state.copyWith(holdings: holdings));
  }
}
