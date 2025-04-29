import 'package:flutter/material.dart';

class CustomPageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const CustomPageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: index == currentPage ? 30 : 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color:
                index == currentPage
                    ? const Color(0xFFFF9E45)
                    : const Color(0xFFFF9E45).withValues(alpha: .5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF9E45).withValues(alpha: .5),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        );
      }),
    );
  }
}
