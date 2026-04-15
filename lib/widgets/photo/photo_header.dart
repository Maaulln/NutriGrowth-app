import 'package:flutter/material.dart';

class PhotoHeader extends StatelessWidget {
  final Function(int)? onNavigate;

  const PhotoHeader({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (onNavigate != null) onNavigate!(0); // go home
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF4CAF82).withValues(alpha: 0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF1A2E2A),
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Photo Detection',
                style: TextStyle(
                  color: Color(0xFF1A2E2A),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'AI-powered measurement',
                style: TextStyle(color: Color(0xFF6B8F80), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
