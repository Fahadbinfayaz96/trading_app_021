import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../data/models/stock_model.dart';
import '../cubits/market_cubit/market_cubit.dart';
import '../cubits/market_cubit/market_state.dart';
import 'price_flash_widget.dart';

class StockListTile extends StatelessWidget {
  final String symbol;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool showRemove;

  const StockListTile({
    super.key,
    required this.symbol,
    this.onTap,
    this.onRemove,
    this.showRemove = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MarketCubit, MarketState, StockModel?>(
      selector: (state) => state.stocks[symbol],
      builder: (context, stock) {
        if (stock == null) return const SizedBox.shrink();

        final isUp = stock.changePaise >= 0;
        final changeColor = isUp ? AppColors.buy : AppColors.sell;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                children: [
                  Container(
                    width: 45.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: changeColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      stock.symbol.isNotEmpty ? stock.symbol[0] : '',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: changeColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stock.symbol,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          stock.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PriceFlashWidget(
                        pricePaise: stock.ltpPaise,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: changeColor,
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isUp
                                  ? Icons.arrow_drop_up_rounded
                                  : Icons.arrow_drop_down_rounded,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                            Text(
                              '${isUp ? '+' : ''}${stock.changePaise.toDecimalString()} (${stock.changePercent.toStringAsFixed(2)}%)',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (showRemove) ...[
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: AppColors.error,
                        size: 20.sp,
                      ),
                      onPressed: onRemove,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
