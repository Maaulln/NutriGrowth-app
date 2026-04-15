import 'package:flutter/material.dart';

class AnalysisHeader extends StatelessWidget {
  final Function(int)? onNavigate;

  const AnalysisHeader({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (onNavigate != null) {
                onNavigate!(0); // go to home
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF4CAF82).withValues(alpha: 0.15),
                ),
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
          const Text(
            'Nutrition Analysis',
            style: TextStyle(
              color: Color(0xFF1A2E2A),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
