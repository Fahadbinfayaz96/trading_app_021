class AppConstants {
  AppConstants._();

  static const Duration defaultTickRate = Duration(milliseconds: 600);
  static const Duration stressTickRate = Duration(milliseconds: 100);

  static const String prefWatchlists = 'watchlists';
  static const String prefHoldings = 'holdings';
  static const String prefOrders = 'orders';
  static const String prefWallet = 'wallet';
  static const String prefOrderCounter = 'order_counter';

  static const int defaultWalletBalancePaise = 100000000;
}
