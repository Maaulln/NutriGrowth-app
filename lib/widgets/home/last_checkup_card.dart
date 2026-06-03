import 'package:flutter/material.dart';
import '../../core/models/stunting_assessment_model.dart';

class LastCheckupCard extends StatelessWidget {
  final StuntingAssessmentSummary? assessment;

  const LastCheckupCard({super.key, this.assessment});

  @override
  Widget build(BuildContext context) {
    if (assessment == null) {
      return _buildEmptyState();
    }
    return _buildDataState(assessment!);
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF82).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.assignment_outlined, size: 40, color: Color(0xFFB0C9BF)),
          SizedBox(height: 12),
          Text(
            'No check-ups yet',
            style: TextStyle(
              color: Color(0xFF1A2E2A),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Run a nutrition analysis to see check-up results.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF86A796), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDataState(StuntingAssessmentSummary data) {
    final date = data.createdAt;
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final dateLabel = '${date.day} ${months[date.month - 1]} ${date.year}';
    final progress = (data.riskScore.clamp(0, 100)) / 100.0;

    final isNormal = data.riskLevel == 'low';
    final statusColor = isNormal ? const Color(0xFF4CAF82) : Colors.orange;
    final statusBg = isNormal ? const Color(0xFFE8F5EE) : const Color(0xFFFFF3E0);
    final statusTextColor = isNormal ? const Color(0xFF2D6A4F) : Colors.orange.shade800;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF82).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateLabel,
                style: const TextStyle(
                  color: Color(0xFF1A2E2A),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data.statusLabel,
                  style: TextStyle(
                    color: statusTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE8F5EE),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Risk score',
                style: TextStyle(color: Color(0xFF86A796), fontSize: 12),
              ),
              Text(
                '${data.riskScore}%',
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (data.summary.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              data.summary,
              style: const TextStyle(color: Color(0xFF6B8F80), fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
