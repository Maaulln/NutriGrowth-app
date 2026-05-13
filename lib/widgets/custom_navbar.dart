import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 65.3,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.9),
                    width: 0.65,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1B4D36).withValues(alpha: 0.14),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: const Color(0xFF1B4D36).withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavItem(index: 0, icon: Icons.home_rounded),
                    const SizedBox(width: 4),
                    _buildNavItem(index: 1, icon: Icons.analytics_outlined),
                    const SizedBox(width: 4),
                    _buildNavItem(index: 2, icon: Icons.restaurant_outlined),
                    const SizedBox(width: 4),
                    _buildNavItem(index: 3, icon: Icons.child_care_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required int index, required IconData icon}) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48,
        height: 48,
        decoration: isSelected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1B4D36), Color(0xFF2D7A55)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B4D36).withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              )
            : const BoxDecoration(color: Colors.transparent),
        child: Center(
          child: Icon(
            icon,
            size: 24,
            color: isSelected ? Colors.white : const Color(0xFF4A6B5D),
          ),
        ),
      ),
    );
  }
}
