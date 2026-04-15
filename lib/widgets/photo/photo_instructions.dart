import 'package:flutter/material.dart';

class PhotoInstructions extends StatelessWidget {
  const PhotoInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instructions',
              style: TextStyle(
                color: Color(0xFF1A2E2A),
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 12),
            _buildInstructionItem(
              '1',
              'Stand child straight against a plain wall',
            ),
            const SizedBox(height: 8),
            _buildInstructionItem('2', 'Ensure good lighting with no shadows'),
            const SizedBox(height: 8),
            _buildInstructionItem(
              '3',
              'Keep the camera at the child\'s full height',
            ),
            const SizedBox(height: 8),
            _buildInstructionItem('4', 'Remove shoes and hats before capture'),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String step, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5EE),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            step,
            style: const TextStyle(
              color: Color(0xFF4CAF82),
              fontSize: 10,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF6B8F80), fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
