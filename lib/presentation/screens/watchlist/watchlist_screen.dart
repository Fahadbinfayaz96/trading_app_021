import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/order_model.dart' as order_state;
import '../../../di/injection_container.dart';
import '../../cubits/watchlist_cubit/watchlist_cubit.dart';
import '../../cubits/watchlist_cubit/watchlist_state.dart';
import '../../widgets/stock_list_tile.dart';
import 'stock_picker_sheet.dart';
import 'watchlist_manager_sheet.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void initState() {
    super.initState();
    getIt<WatchlistCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.watchlist,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              icon: Icon(
                Icons.playlist_add_check_rounded,
                color: AppColors.secondary,
              ),
              onPressed: () => _showWatchlistManager(context),
            ),
          ),
        ],
      ),
      body: BlocBuilder<WatchlistCubit, WatchlistState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
            );
          }

          if (state.watchlists.isEmpty) {
            return _buildEmptyState();
          }

          final active = state.activeWatchlist;

          return Column(
            children: [
              SizedBox(height: 10.h),
              Container(
                height: 44.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.watchlists.length,
                  separatorBuilder: (_, _) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final wl = state.watchlists[index];
                    final isActive = index == state.activeIndex;

                    return ChoiceChip(
                      label: Text(wl.name),
                      selected: isActive,
                      onSelected: (_) =>
                          context.read<WatchlistCubit>().setActive(index),
                      showCheckmark: false,
                      elevation: 0,
                      pressElevation: 0,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      selectedColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        side: BorderSide.none,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 8.h),

              // Stock list
              Expanded(
                child: active == null || active.stockSymbols.isEmpty
                    ? _buildEmptyState()
                    : ReorderableListView.builder(
                        padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 88.h),
                        itemCount: active.stockSymbols.length,
                        onReorder: (oldIndex, newIndex) {
                          context.read<WatchlistCubit>().reorderStocks(
                            oldIndex,
                            newIndex,
                          );
                        },
                        proxyDecorator: (child, index, animation) {
                          return Material(
                            color: Colors.transparent,
                            elevation: 8,
                            shadowColor: Colors.black38,
                            borderRadius: BorderRadius.circular(16.r),
                            child: child,
                          );
                        },
                        itemBuilder: (context, index) {
                          final symbol = active.stockSymbols[index];
                          return Container(
                            key: ValueKey(symbol),
                            margin: EdgeInsets.only(bottom: 10.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: StockListTile(
                              symbol: symbol,
                              showRemove: true,
                              onTap: () => context.push(
                                '/order',
                                extra: {
                                  'symbol': symbol,
                                  'side': order_state.OrderSide.buy,
                                },
                              ),
                              onRemove: () => context
                                  .read<WatchlistCubit>()
                                  .removeStock(symbol),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showStockPicker(context),
        icon: const Icon(Icons.add),
        label: const Text(
          AppStrings.addStocks,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 4,
      ),
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
                Icons.folder_open_outlined,
                size: 52.sp,
                color: AppColors.secondary,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              AppStrings.emptyWatchlist,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.sp, height: 1.4),
            ),
            SizedBox(height: 12.h),
            TextButton.icon(
              onPressed: () => _showStockPicker(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                AppStrings.addStocks,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondary,
                backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStockPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => const StockPickerSheet(),
    );
  }

  void _showWatchlistManager(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => const WatchlistManagerSheet(),
    );
  }
}
