import 'package:equatable/equatable.dart';
import '../../../data/models/holding_model.dart';

enum HoldingsSort { pnlDesc, pnlAsc, symbol, valueDesc }

class HoldingsState extends Equatable {
  final List<HoldingModel> holdings;
  final HoldingsSort sort;
  final bool isLoading;

  const HoldingsState({
    this.holdings = const [],
    this.sort = HoldingsSort.pnlDesc,
    this.isLoading = true,
  });

  HoldingsState copyWith({
    List<HoldingModel>? holdings,
    HoldingsSort? sort,
    bool? isLoading,
  }) {
    return HoldingsState(
      holdings: holdings ?? this.holdings,
      sort: sort ?? this.sort,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [holdings, sort, isLoading];
}
