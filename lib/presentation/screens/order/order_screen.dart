import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../cubits/market_cubit/market_cubit.dart';
import '../../cubits/market_cubit/market_state.dart';
import '../../cubits/order_cubit/order_cubit.dart';
import '../../cubits/order_cubit/order_state.dart';
import '../../cubits/wallet _cubit/wallet_cubit.dart';
import '../../cubits/wallet _cubit/wallet_state.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _qtyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final marketCubit = context.read<MarketCubit>();
    final orderCubit = context.read<OrderCubit>();

    final stock = marketCubit.getStock(orderCubit.state.symbol);
    if (stock != null) {
      orderCubit.updateLtp(stock.ltpPaise);
    }
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Place Order',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: BlocListener<OrderCubit, OrderState>(
        listenWhen: (prev, curr) =>
            prev.isSuccess != curr.isSuccess && curr.isSuccess,
        listener: (context, state) {
          context.pushReplacement('/order-confirmation');
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stock Selector & Live Price
                BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, orderState) {
                    return BlocBuilder<MarketCubit, MarketState>(
                      builder: (context, marketState) {
                        final stock = marketState.stocks[orderState.symbol];
                        if (stock != null &&
                            stock.ltpPaise != orderState.ltpPaise) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              context.read<OrderCubit>().updateLtp(
                                stock.ltpPaise,
                              );
                            }
                          });
                        }

                        final isUp = stock != null && stock.changePaise >= 0;
                        final tint = isUp ? AppColors.buy : AppColors.sell;

                        return Container(
                          padding: EdgeInsets.all(18.w),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 46.w,
                                    height: 46.w,
                                    decoration: BoxDecoration(
                                      color: tint.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      orderState.symbol.isNotEmpty
                                          ? orderState.symbol[0]
                                          : '',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w800,
                                        color: tint,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orderState.symbol,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ).copyWith(fontSize: 18.sp),
                                      ),
                                      if (stock != null)
                                        Text(
                                          stock.name,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    stock?.ltpPaise.toRupeeString() ?? '--',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (stock != null)
                                    Container(
                                      margin: EdgeInsets.only(top: 4.h),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: tint,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Text(
                                        '${isUp ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                SizedBox(height: 20.h),

                // Buy / Sell Toggle
                BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, state) {
                    return Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildSideButton(
                              label: AppStrings.buy,
                              isSelected: state.side == OrderSide.buy,
                              color: AppColors.buy,
                              onTap: () => context.read<OrderCubit>().setSide(
                                OrderSide.buy,
                              ),
                            ),
                          ),
                          Expanded(
                            child: _buildSideButton(
                              label: AppStrings.sell,
                              isSelected: state.side == OrderSide.sell,
                              color: AppColors.sell,
                              onTap: () => context.read<OrderCubit>().setSide(
                                OrderSide.sell,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: 24.h),

                Text(
                  AppStrings.quantity,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: _qtyController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [AppInputFormatters.quantity],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(hintText: 'Enter quantity'),
                  onChanged: (val) {
                    final qty = int.tryParse(val) ?? 0;
                    context.read<OrderCubit>().setQuantity(qty);
                  },
                ),

                SizedBox(height: 20.h),

                // Order Value & Balance
                BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, orderState) {
                    return BlocBuilder<WalletCubit, WalletState>(
                      builder: (context, walletState) {
                        final insufficient =
                            orderState.side == OrderSide.buy &&
                            orderState.orderValuePaise >
                                walletState.balancePaise;

                        return Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: insufficient
                                ? AppColors.error.withValues(alpha: 0.08)
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(14.r),
                            border: insufficient
                                ? Border.all(
                                    color: AppColors.error.withValues(
                                      alpha: 0.4,
                                    ),
                                  )
                                : null,
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                'Order Value',
                                orderState.orderValuePaise.toRupeeString(),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Divider(
                                  height: 1.h,
                                  color: Theme.of(
                                    context,
                                  ).dividerColor.withValues(alpha: 0.3),
                                ),
                              ),
                              _buildInfoRow(
                                AppStrings.availableBalance,
                                walletState.balancePaise.toRupeeString(),
                              ),
                              if (insufficient)
                                Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 14.sp,
                                        color: AppColors.error,
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        AppStrings.insufficientBalance,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                SizedBox(height: 24.h),

                // Error
                BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, state) {
                    if (state.error == null) return const SizedBox.shrink();
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Text(
                        state.error!,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 13.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),

                // Submit Button
                BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, state) {
                    final isValid =
                        state.quantity > 0 &&
                        state.ltpPaise != null &&
                        state.error == null;

                    return SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: ElevatedButton(
                        onPressed: state.isSubmitting || !isValid
                            ? null
                            : () => context.read<OrderCubit>().submit(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state.side == OrderSide.buy
                              ? AppColors.buy
                              : AppColors.sell,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          elevation: 4,
                          shadowColor:
                              (state.side == OrderSide.buy
                                      ? AppColors.buy
                                      : AppColors.sell)
                                  .withValues(alpha: 0.4),
                        ),
                        child: state.isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                '${state.side == OrderSide.buy ? AppStrings.buy : AppStrings.sell} ${state.symbol}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSideButton({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(11.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
