import 'package:flutter/material.dart';

/// Shimmer loading placeholder for dashboard
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Banner shimmer
          const _ShimmerBox(
            height: 180,
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
          const SizedBox(height: 24),
          // Section shimmer
          _buildSectionShimmer(),
          const SizedBox(height: 24),
          _buildSectionShimmer(),
        ],
      ),
    );
  }

  Widget _buildSectionShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title shimmer
        const _ShimmerBox(
          height: 24,
          width: 150,
          margin: EdgeInsets.symmetric(horizontal: 16),
        ),
        const SizedBox(height: 12),
        // Products shimmer
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBox(height: 120),
                    SizedBox(height: 12),
                    _ShimmerBox(height: 16, width: 140),
                    SizedBox(height: 8),
                    _ShimmerBox(height: 14, width: 80),
                    SizedBox(height: 8),
                    _ShimmerBox(height: 18, width: 60),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Shimmer box widget
class _ShimmerBox extends StatefulWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry margin;

  const _ShimmerBox({
    this.height,
    this.width,
    this.margin = EdgeInsets.zero,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300]?.withOpacity(_animation.value),
          ),
        );
      },
    );
  }
}
