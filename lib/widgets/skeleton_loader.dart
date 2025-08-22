import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;
  
  const SkeletonLoader({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
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
          decoration: BoxDecoration(
            color: const Color(0xFFE8E0D6).withOpacity(_animation.value),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF5F5DC),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SkeletonLoader(
              height: 56,
              width: 56,
              borderRadius: BorderRadius.circular(28),
            ),
            const SizedBox(height: 12),
            const SkeletonLoader(
              height: 16,
              width: 80,
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonText extends StatelessWidget {
  final double height;
  final double? width;
  
  const SkeletonText({
    super.key,
    this.height = 16,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      height: height,
      width: width ?? MediaQuery.of(context).size.width * 0.7,
    );
  }
}