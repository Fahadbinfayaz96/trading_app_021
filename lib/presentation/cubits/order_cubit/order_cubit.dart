import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/holding_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/holding_repository.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../holdings_cubit/holdings_cubit.dart';
import '../wallet _cubit/wallet_cubit.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final WalletRepository _walletRepo;
  final HoldingsRepository _holdingsRepo;
  final OrdersRepository _ordersRepo;

  final WalletCubit _walletCubit;
  final HoldingsCubit _holdingsCubit;

  OrderCubit(
    this._walletRepo,
    this._holdingsRepo,
    this._ordersRepo,
    this._walletCubit,
    this._holdingsCubit, {
    required String symbol,
    OrderSide side = OrderSide.buy,
  }) : super(OrderState(symbol: symbol, side: side));

  void setSymbol(String symbol) => emit(state.copyWith(symbol: symbol));
  void setSide(OrderSide side) => emit(state.copyWith(side: side));
  Future<void> setQuantity(int qty) async {
    String? error;

    if (qty <= 0) {
      error = 'Enter a valid quantity';
    } else if (state.side == OrderSide.sell) {
      final holdings = await _holdingsRepo.getHoldings();
      final holding = holdings.firstWhere(
        (h) => h.symbol == state.symbol,
        orElse: () =>
            const HoldingModel(symbol: '', quantity: 0, avgCostPaise: 0),
      );
      if (holding.quantity < qty) {
        error = 'Insufficient quantity';
      }
    }

    emit(state.copyWith(quantity: qty, error: error));
  }

  void updateLtp(int ltpPaise) =>
      emit(state.copyWith(ltpPaise: ltpPaise, error: state.error));

  Future<void> submit() async {
    emit(state.copyWith(error: null, isSubmitting: true));

    if (state.quantity <= 0) {
      emit(
        state.copyWith(error: 'Enter a valid quantity', isSubmitting: false),
      );
      return;
    }

    final ltp = state.ltpPaise;
    if (ltp == null || ltp <= 0) {
      emit(state.copyWith(error: 'Price unavailable', isSubmitting: false));
      return;
    }

    final value = state.quantity * ltp;

    if (state.side == OrderSide.buy) {
      final wallet = await _walletRepo.getWallet();
      if (wallet.balancePaise < value) {
        emit(
          state.copyWith(error: 'Insufficient balance', isSubmitting: false),
        );
        return;
      }
      await _walletRepo.updateBalance(-value);
      await _holdingsRepo.updateHolding(state.symbol, state.quantity, ltp);

      await _walletCubit.load();
      await _holdingsCubit.refresh();
    } else {
      final holdings = await _holdingsRepo.getHoldings();
      final holding = holdings.firstWhere(
        (h) => h.symbol == state.symbol,
        orElse: () =>
            const HoldingModel(symbol: '', quantity: 0, avgCostPaise: 0),
      );
      if (holding.quantity < state.quantity) {
        emit(
          state.copyWith(error: 'Insufficient quantity', isSubmitting: false),
        );
        return;
      }
      await _walletRepo.updateBalance(value);
      await _holdingsRepo.reduceHolding(state.symbol, state.quantity);

      await _walletCubit.load();
      await _holdingsCubit.refresh();
    }

    final order = OrderModel(
      id: const Uuid().v4(),
      symbol: state.symbol,
      side: state.side,
      quantity: state.quantity,
      pricePaise: ltp,
      timestamp: DateTime.now(),
    );
    await _ordersRepo.addOrder(order);

    emit(state.copyWith(isSubmitting: false, isSuccess: true));
  }

  void resetSuccess() => emit(state.copyWith(isSuccess: false));
}
