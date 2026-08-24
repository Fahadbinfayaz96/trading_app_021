import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/models/order_model.dart' as order_state;
import '../../../di/injection_container.dart';
import '../../cubits/holdings_cubit/holdings_cubit.dart';
import '../../cubits/holdings_cubit/holdings_state.dart';
import '../../cubits/market_cubit/market_cubit.dart';
import '../../cubits/market_cubit/market_state.dart';

class HoldingsScreen extends StatefulWidget {
  const HoldingsScreen({super.key});

  @override
  State<HoldingsScreen> createState() => _HoldingsScreenState();
}

class _HoldingsScreenState extends State<HoldingsScreen> {
  @override
  void initState() {
    super.initState();
    getIt<HoldingsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.holdings,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: PopupMenuButton<HoldingsSort>(
              icon: Icon(Icons.sort_rounded, color: AppColors.secondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              onSelected: (sort) => context.read<HoldingsCubit>().setSort(sort),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: HoldingsSort.pnlDesc,
                  child: Text('P&L: High to Low'),
                ),
                const PopupMenuItem(
                  value: HoldingsSort.pnlAsc,
                  child: Text('P&L: Low to High'),
                ),
                const PopupMenuItem(
                  value: HoldingsSort.symbol,
                  child: Text('Symbol A-Z'),
                ),
                const PopupMenuItem(
                  value: HoldingsSort.valueDesc,
                  child: Text('Value: High to Low'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<HoldingsCubit, HoldingsState>(
        builder: (context, holdingsState) {
          if (holdingsState.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
            );
          }

          if (holdingsState.holdings.isEmpty) {
            return _buildEmptyState();
          }

          return BlocBuilder<MarketCubit, MarketState>(
            builder: (context, marketState) {
              final livePrices = {
                for (final s in marketState.stocks.entries)
                  s.key: s.value.ltpPaise,
              };

              final sorted = context.read<HoldingsCubit>().getSortedHoldings(
                livePrices,
              );

              int totalInvested = 0;
              int totalCurrent = 0;
              for (final h in holdingsState.holdings) {
                totalInvested += h.quantity * h.avgCostPaise;
                totalCurrent +=
                    h.quantity * (livePrices[h.symbol] ?? h.avgCostPaise);
              }
              final totalPnl = totalCurrent - totalInvested;
              final totalPnlPercent = totalInvested > 0
                  ? (totalPnl / totalInvested) * 100
                  : 0.0;
              final isTotalProfit = totalPnl >= 0;
              final pnlColor = isTotalProfit ? AppColors.buy : AppColors.sell;

              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _summaryItem(
                              'Invested',
                              totalInvested.toRupeeString(),
                            ),
                            _summaryItem(
                              'Current',
                              totalCurrent.toRupeeString(),
                              alignEnd: true,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Divider(
                          height: 1.h,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _summaryItem(
                              'Total P&L',
                              '${isTotalProfit ? '+' : ''}${totalPnl.toRupeeString()}',
                              valueColor: pnlColor,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: pnlColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                '${isTotalProfit ? '+' : ''}${totalPnlPercent.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                      itemCount: sorted.length,
                      separatorBuilder: (_, _) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final holding = sorted[index];
                        final ltp =
                            livePrices[holding.symbol] ?? holding.avgCostPaise;
                        final currentValue = holding.quantity * ltp;
                        final invested =
                            holding.quantity * holding.avgCostPaise;
                        final pnl = currentValue - invested;
                        final pnlPercent = invested > 0
                            ? (pnl / invested) * 100
                            : 0.0;
                        final isProfit = pnl >= 0;
                        final rowColor = isProfit
                            ? AppColors.buy
                            : AppColors.sell;

                        return Material(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          child: InkWell(
                            onTap: () => context.push(
                              '/order',
                              extra: {
                                'symbol': holding.symbol,
                                'side': order_state.OrderSide.sell,
                              },
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          holding.symbol,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Qty: ${holding.quantity}',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        Text(
                                          'Avg: ${holding.avgCostPaise.toRupeeString()}',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          ltp.toRupeeString(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          currentValue.toRupeeString(),
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${isProfit ? '+' : ''}${pnl.toRupeeString()}',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w800,
                                            color: rowColor,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 7.w,
                                            vertical: 3.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: rowColor,
                                            borderRadius: BorderRadius.circular(
                                              7.r,
                                            ),
                                          ),
                                          child: Text(
                                            '${isProfit ? '+' : ''}${pnlPercent.toStringAsFixed(2)}%',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _summaryItem(
    String label,
    String value, {
    Color? valueColor,
    bool alignEnd = false,
  }) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.white.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w800,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(22.w),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 52.sp,
                color: AppColors.secondary,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              AppStrings.emptyHoldings,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.sp, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
