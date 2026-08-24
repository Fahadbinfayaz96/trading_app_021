import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: EdgeInsets.all(26.w),
                decoration: BoxDecoration(
                  color: AppColors.buy.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: const BoxDecoration(
                    color: AppColors.buy,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 44.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              Text(
                AppStrings.orderSuccess,
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                'Your order has been executed at the current market price.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () => context.go('/holdings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.secondary.withValues(alpha: 0.4),
                  ),
                  child: const Text(
                    'View Holdings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () => context.go('/watchlist'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: const Text(
                  'Back to Watchlist',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
