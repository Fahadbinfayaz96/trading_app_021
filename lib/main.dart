import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trading_app_021/di/injection_container.dart';

import 'core/theme/app_theme.dart';
import 'data/services/market_data_service.dart';
import 'presentation/cubits/holdings_cubit/holdings_cubit.dart';
import 'presentation/cubits/market_cubit/market_cubit.dart';
import 'presentation/cubits/wallet _cubit/wallet_cubit.dart';
import 'presentation/cubits/watchlist_cubit/watchlist_cubit.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await initDependencies();

  await getIt<WalletCubit>().load();

  runApp(const TradingApp());
}

class TradingApp extends StatelessWidget {
  const TradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<MarketCubit>(
              create: (_) {
                final cubit = getIt<MarketCubit>();

                getIt<MarketDataService>().start();
                cubit.startFeed();

                return cubit;
              },
            ),

            BlocProvider<WatchlistCubit>(
              create: (_) => getIt<WatchlistCubit>(),
            ),

            BlocProvider<HoldingsCubit>(create: (_) => getIt<HoldingsCubit>()),

            BlocProvider<WalletCubit>(create: (_) => getIt<WalletCubit>()),
          ],
          child: MaterialApp.router(
            title: '021 Trade',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
