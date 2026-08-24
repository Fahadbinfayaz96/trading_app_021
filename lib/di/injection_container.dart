import 'package:get_it/get_it.dart';
import '../data/repositories/holding_repository.dart';
import '../data/repositories/market_repository.dart';
import '../data/repositories/order_repository.dart';
import '../data/repositories/wallet_repository.dart';
import '../data/repositories/watchlist_repository.dart';
import '../data/services/local_storage_service.dart';
import '../data/services/market_data_service.dart';
import '../presentation/cubits/holdings_cubit/holdings_cubit.dart';
import '../presentation/cubits/market_cubit/market_cubit.dart';
import '../presentation/cubits/wallet _cubit/wallet_cubit.dart';
import '../presentation/cubits/watchlist_cubit/watchlist_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final localStorage = LocalStorageService();
  await localStorage.init();
  getIt.registerSingleton<LocalStorageService>(localStorage);

  final marketService = MarketDataService();
  getIt.registerSingleton<MarketDataService>(marketService);

  getIt.registerLazySingleton<MarketRepository>(
    () => MarketRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<WatchlistRepository>(
    () => WatchlistRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<HoldingsRepository>(
    () => HoldingsRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(getIt()),
  );

  getIt.registerSingleton<MarketCubit>(MarketCubit(getIt()));
  getIt.registerSingleton<WatchlistCubit>(WatchlistCubit(getIt()));
  getIt.registerSingleton<HoldingsCubit>(HoldingsCubit(getIt()));
  getIt.registerSingleton<WalletCubit>(WalletCubit(getIt()));
}
