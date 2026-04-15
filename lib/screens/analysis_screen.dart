import 'package:flutter/material.dart';
import '../widgets/analysis/analysis_header.dart';
import '../widgets/analysis/analysis_info_box.dart';
import '../widgets/analysis/analysis_form.dart';
import '../widgets/analysis/analysis_result_box.dart';

class AnalysisScreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const AnalysisScreen({super.key, this.onNavigate});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _muacController = TextEditingController();

  bool _isAnalyzing = false;
  String? _analysisStatus;
  String? _analysisRecommendation;
  Color? _statusColor;

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _muacController.dispose();
    super.dispose();
  }

  void _analyzeData() {
    // Basic validation
    if (_ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _muacController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisStatus = null;
    });

    // Simulate AI analysis delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final weight = double.tryParse(_weightController.text) ?? 0;
      final age = int.tryParse(_ageController.text) ?? 0;

      // Dummy logic for demonstration purposes
      String status;
      String recommendation;
      Color color;

      if (weight < (age * 0.5) + 4) {
        // Dummy formula for underweight
        status = 'Needs Attention';
        color = Colors.orange;
        recommendation =
            'Weight is below average for this age. Recommend consulting a pediatrician and increasing protein intake.';
      } else if (weight > (age * 0.5) + 12) {
        // Dummy formula for overweight
        status = 'Overweight';
        color = Colors.redAccent;
        recommendation =
            'Weight is above average. Please monitor diet and encourage active playtime.';
      } else {
        status = 'Healthy Growth';
        color = const Color(0xFF4CAF82);
        recommendation =
            'Your child is growing perfectly! Keep up the good work with balanced nutrition.';
      }

      setState(() {
        _isAnalyzing = false;
        _analysisStatus = status;
        _analysisRecommendation = recommendation;
        _statusColor = color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F4),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnalysisHeader(onNavigate: widget.onNavigate),
              const AnalysisInfoBox(),
              const SizedBox(height: 24),
              AnalysisForm(
                ageController: _ageController,
                weightController: _weightController,
                heightController: _heightController,
                muacController: _muacController,
                isAnalyzing: _isAnalyzing,
                onAnalyze: _analyzeData,
              ),
              if (_analysisStatus != null) ...[
                const SizedBox(height: 24),
                AnalysisResultBox(
                  status: _analysisStatus!,
                  recommendation: _analysisRecommendation!,
                  color: _statusColor!,
                ),
                const SizedBox(height: 100), // padding for bottom nav
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
