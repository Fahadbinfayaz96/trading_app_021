import '../../core/constants/app_constants.dart';
import '../models/wallet_model.dart';
import '../services/local_storage_service.dart';

abstract class WalletRepository {
  Future<WalletModel> getWallet();
  Future<void> updateBalance(int deltaPaise);
  Future<void> reset();
}

class WalletRepositoryImpl implements WalletRepository {
  final LocalStorageService _storage;

  WalletRepositoryImpl(this._storage);

  @override
  Future<WalletModel> getWallet() async {
    final balance = _storage.getWallet();
    if (balance == null) {
      const wallet = WalletModel(
        balancePaise: AppConstants.defaultWalletBalancePaise,
      );
      await _storage.saveWallet(wallet.balancePaise);
      return wallet;
    }
    return WalletModel(balancePaise: balance);
  }

  @override
  Future<void> updateBalance(int deltaPaise) async {
    final wallet = await getWallet();
    final newBalance = wallet.balancePaise + deltaPaise;
    await _storage.saveWallet(newBalance);
  }

  @override
  Future<void> reset() async {
    await _storage.saveWallet(AppConstants.defaultWalletBalancePaise);
  }
}
