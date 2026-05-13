import 'package:flutter/material.dart';
import '../core/models/nutrition_analysis_model.dart';
import '../core/services/nutrition_ai_service.dart';
import '../core/services/food_service.dart';
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
  int _selectedGender = 1;

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

  /// Mengirim data input ke API AI untuk mendapatkan hasil analisis gizi.
  Future<void> _analyzeData() async {
    // Validasi input dasar sebelum request ke API.
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

    final ageMonths = int.tryParse(_ageController.text.trim());
    final weightKg = double.tryParse(_weightController.text.trim());
    final heightCm = double.tryParse(_heightController.text.trim());
    final muacCm = double.tryParse(_muacController.text.trim());

    if (ageMonths == null ||
        weightKg == null ||
        heightCm == null ||
        muacCm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid numeric values'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisStatus = null;
    });

    try {
      final request = NutritionAnalysisRequest(
        ageMonths: ageMonths,
        gender: _selectedGender,
        weightKg: weightKg,
        heightCm: heightCm,
        muacCm: muacCm,
      );

      final result = await NutritionAiService.instance.analyzeNutrition(
        request,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isAnalyzing = false;
        _analysisStatus = result.status;
        _analysisRecommendation = result.recommendation;
        _statusColor = _mapStatusColor(result.status);
      });
    } on NutritionAiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isAnalyzing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  /// Memetakan label status dari API ke warna visual hasil analisis.
  Color _mapStatusColor(String status) {
    final normalized = status.toLowerCase();
    if (normalized.contains('healthy') || normalized.contains('normal')) {
      return const Color(0xFF4CAF82);
    }
    if (normalized.contains('over') || normalized.contains('obes')) {
      return Colors.redAccent;
    }
    return Colors.orange;
  }

  /// Memetakan status gizi ke kategori makanan yang disarankan.
  String? _mapStatusToCategory(String status) {
    final normalized = status.toLowerCase();
    if (normalized.contains('severe thinness') ||
        normalized.contains('thinness')) {
      return 'Protein';
    }
    if (normalized.contains('overweight') || normalized.contains('obesity')) {
      return 'Vegetable';
    }
    if (normalized.contains('healthy') || normalized.contains('normal')) {
      return 'All';
    }
    return 'Protein'; // Default recommendation
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
                selectedGender: _selectedGender,
                onGenderChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                isAnalyzing: _isAnalyzing,
                onAnalyze: _analyzeData,
              ),
              if (_analysisStatus != null) ...[
                const SizedBox(height: 24),
                AnalysisResultBox(
                  status: _analysisStatus!,
                  recommendation: _analysisRecommendation!,
                  color: _statusColor!,
                  onSeeFood: () {
                    // Set the pending category based on analysis result
                    FoodService.instance.pendingCategory = _mapStatusToCategory(
                      _analysisStatus!,
                    );

                    if (widget.onNavigate != null) {
                      widget.onNavigate!(2); // Navigate to Food tab
                    }
                  },
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
