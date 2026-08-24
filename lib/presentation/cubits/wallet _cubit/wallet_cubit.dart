import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/wallet_repository.dart';
import 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepository _repository;

  WalletCubit(this._repository) : super(const WalletState());

  Future<void> load() async {
    final wallet = await _repository.getWallet();
    emit(state.copyWith(balancePaise: wallet.balancePaise, isLoading: false));
  }

  Future<void> deduct(int amountPaise) async {
    await _repository.updateBalance(-amountPaise);
    final wallet = await _repository.getWallet();
    emit(state.copyWith(balancePaise: wallet.balancePaise));
  }

  Future<void> credit(int amountPaise) async {
    await _repository.updateBalance(amountPaise);
    final wallet = await _repository.getWallet();
    emit(state.copyWith(balancePaise: wallet.balancePaise));
  }
}
