import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _getIndex(String location) {
    if (location.startsWith('/market')) return 1;
    if (location.startsWith('/holdings')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final theme = Theme.of(context);

    return Scaffold(
      body: child,

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 8),
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: NavigationBar(
              height: 68,
              elevation: 0,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,

              selectedIndex: _getIndex(location),

              indicatorColor: theme.colorScheme.primary,

              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

              onDestinationSelected: (index) {
                switch (index) {
                  case 0:
                    context.go('/watchlist');
                    break;
                  case 1:
                    context.go('/market');
                    break;
                  case 2:
                    context.go('/holdings');
                    break;
                }
              },

              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.list_alt_outlined, size: 24),
                  selectedIcon: Icon(Icons.list_alt, size: 25),
                  label: AppStrings.watchlist,
                ),
                NavigationDestination(
                  icon: Icon(Icons.show_chart_outlined, size: 24),
                  selectedIcon: Icon(Icons.show_chart, size: 25),
                  label: AppStrings.market,
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_balance_wallet_outlined, size: 24),
                  selectedIcon: Icon(Icons.account_balance_wallet, size: 25),
                  label: AppStrings.holdings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
