import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PriceFlashWidget extends StatefulWidget {
  final int pricePaise;
  final TextStyle? style;
  const PriceFlashWidget({super.key, required this.pricePaise, this.style});

  @override
  State<PriceFlashWidget> createState() => _PriceFlashWidgetState();
}

class _PriceFlashWidgetState extends State<PriceFlashWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _lastPrice;
  Color _flashColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _lastPrice = widget.pricePaise;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _flashColor = Colors.transparent);
      }
    });
  }

  @override
  void didUpdateWidget(covariant PriceFlashWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pricePaise != _lastPrice) {
      final isUp = widget.pricePaise > _lastPrice;
      _flashColor = isUp
          ? AppColors.buy.withValues(alpha: 0.35)
          : AppColors.sell.withValues(alpha: 0.35);
      _lastPrice = widget.pricePaise;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: Color.lerp(
              _flashColor,
              Colors.transparent,
              _controller.value,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: child,
        );
      },
      child: Text(
        '₹${(widget.pricePaise / 100).toStringAsFixed(2)}',
        style: widget.style,
      ),
    );
  }
}
