import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Rectangle skeleton animé avec effet shimmer.
/// Usage : SkeletonBox(width: double.infinity, height: 20)
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    required this.height,
    this.width = double.infinity,
    this.borderRadius = 8,
    super.key,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE0E0E0),
      highlightColor: isDark
          ? const Color(0xFF4A4A4A)
          : const Color(0xFFF5F5F5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
