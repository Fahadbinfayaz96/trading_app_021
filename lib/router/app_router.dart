import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../data/models/order_model.dart';
import '../di/injection_container.dart';
import '../presentation/cubits/holdings_cubit/holdings_cubit.dart';
import '../presentation/cubits/order_cubit/order_cubit.dart';
import '../presentation/cubits/wallet _cubit/wallet_cubit.dart';
import '../presentation/screens/holdings/holding_screen.dart';
import '../presentation/screens/main_shell.dart';
import '../presentation/screens/market/market_screen.dart';
import '../presentation/screens/order/order_confirmation_screen.dart';
import '../presentation/screens/order/order_screen.dart';
import '../presentation/screens/watchlist/watchlist_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/watchlist',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/watchlist',
            builder: (_, _) => const WatchlistScreen(),
          ),
          GoRoute(path: '/market', builder: (_, _) => const MarketScreen()),
          GoRoute(path: '/holdings', builder: (_, _) => const HoldingsScreen()),
        ],
      ),
      GoRoute(
        path: '/order',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};

          final symbol = extra['symbol'] as String? ?? 'RELIANCE';

          final side = extra['side'] as OrderSide? ?? OrderSide.buy;

          return BlocProvider(
            create: (_) => OrderCubit(
              getIt(),
              getIt(),
              getIt(),
              getIt<WalletCubit>(),
              getIt<HoldingsCubit>(),
              symbol: symbol,
              side: side,
            ),
            child: const OrderScreen(),
          );
        },
      ),
      GoRoute(
        path: '/order-confirmation',
        builder: (_, _) => const OrderConfirmationScreen(),
      ),
    ],
  );
}
