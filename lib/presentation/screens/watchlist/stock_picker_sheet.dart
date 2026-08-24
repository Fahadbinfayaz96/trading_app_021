import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/models/stock_model.dart';
import '../../cubits/market_cubit/market_cubit.dart';
import '../../cubits/market_cubit/market_state.dart';
import '../../cubits/watchlist_cubit/watchlist_cubit.dart';

class StockPickerSheet extends StatelessWidget {
  const StockPickerSheet({super.key});

  final List<String> _allSymbols = const [
    'RELIANCE',
    'TCS',
    'INFY',
    'HDFCBANK',
    'ICICIBANK',
    'SBIN',
    'ITC',
    'LT',
    'BHARTIARTL',
    'AXISBANK',
  ];

  @override
  Widget build(BuildContext context) {
    final watchlistCubit = context.read<WatchlistCubit>();
    final activeSymbols =
        watchlistCubit.state.activeWatchlist?.stockSymbols ?? [];

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add Stocks',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  itemCount: _allSymbols.length,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final symbol = _allSymbols[index];
                    final isAdded = activeSymbols.contains(symbol);

                    return BlocSelector<MarketCubit, MarketState, StockModel?>(
                      selector: (state) => state.stocks[symbol],
                      builder: (context, stock) {
                        if (stock == null) return const SizedBox.shrink();
                        final isUp = stock.changePaise >= 0;
                        final tint = isUp ? AppColors.buy : AppColors.sell;

                        return Container(
                          decoration: BoxDecoration(
                            color: isAdded
                                ? Theme.of(
                                    context,
                                  ).colorScheme.surface.withValues(alpha: 0.5)
                                : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: isAdded
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.04,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            enabled: !isAdded,
                            leading: Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: tint.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(11.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                symbol[0],
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w800,
                                  color: tint,
                                ),
                              ),
                            ),
                            title: Text(
                              symbol,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: isAdded ? Colors.grey : null,
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text(
                                stock.name,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            trailing: isAdded
                                ? Icon(
                                    Icons.check_circle,
                                    color: AppColors.secondary,
                                    size: 22.sp,
                                  )
                                : Text(
                                    stock.ltpPaise.toRupeeString(),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                            onTap: isAdded
                                ? null
                                : () {
                                    watchlistCubit.addStock(symbol);
                                    context.pop();
                                  },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
