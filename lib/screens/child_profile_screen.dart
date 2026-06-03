import 'package:flutter/material.dart';
import '../core/models/child_model.dart';
import 'add_child_screen.dart';

class ChildProfileScreen extends StatefulWidget {
  final Child child;
  const ChildProfileScreen({super.key, required this.child});

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  late Child _child;

  @override
  void initState() {
    super.initState();
    _child = widget.child;
  }

  /// Membuka form edit anak lalu memperbarui state lokal jika sukses disimpan.
  Future<void> _openEditChild() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddChildScreen(initialChild: _child),
      ),
    );

    if (!mounted || result is! Child) {
      return;
    }

    setState(() {
      _child = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMale = _child.isMale;
    final weightText = _child.weightKg == null
        ? 'Not available'
        : '${_child.weightLabel} kg';
    final heightText = _child.heightCm == null
        ? 'Not available'
        : '${_child.heightLabel} cm';
    final muacText = _child.muacCm == null
        ? 'Not available'
        : '${_child.muacLabel} cm';

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Back Button
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(
                            0xFF4CAF82,
                          ).withValues(alpha: 0.15),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1A2E2A),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Child Profile',
                      style: TextStyle(
                        color: Color(0xFF1A2E2A),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _openEditChild,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2E8B57),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Avatar
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isMale
                          ? [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)]
                          : [const Color(0xFFFCE4EC), const Color(0xFFF8BBD0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: (isMale ? Colors.blue : Colors.pink).withValues(
                          alpha: 0.2,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    isMale ? Icons.boy : Icons.girl,
                    size: 60,
                    color: isMale ? Colors.blue : Colors.pink,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Name and Age
              Center(
                child: Text(
                  _child.name,
                  style: const TextStyle(
                    color: Color(0xFF1A2E2A),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  _child.ageFormatted,
                  style: const TextStyle(
                    color: Color(0xFF6B8F80),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Metrics Section
              const Text(
                'GROWTH METRICS',
                style: TextStyle(
                  color: Color(0xFF86A796),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailItem(
                Icons.monitor_weight_outlined,
                'Weight',
                weightText,
              ),
              _buildDetailItem(Icons.height_rounded, 'Height', heightText),
              _buildDetailItem(
                Icons.accessibility_new_rounded,
                'MUAC',
                muacText,
              ),
              const SizedBox(height: 32),

              // General Info Section
              const Text(
                'GENERAL INFO',
                style: TextStyle(
                  color: Color(0xFF86A796),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailItem(
                Icons.calendar_today_rounded,
                'Date of Birth',
                '${_child.birthDate.day} ${_getMonthName(_child.birthDate.month)} ${_child.birthDate.year}',
              ),
              _buildDetailItem(
                isMale ? Icons.male_rounded : Icons.female_rounded,
                'Gender',
                _child.genderLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4CAF82).withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF82).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF2E8B57), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF6B8F80),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1A2E2A),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
