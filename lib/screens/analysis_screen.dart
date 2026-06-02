import 'package:flutter/material.dart';
import '../core/models/nutrition_analysis_model.dart';
import '../core/services/auth_service.dart';
import '../core/services/child_service.dart';
import '../core/services/nutrition_ai_service.dart';
import '../widgets/analysis/analysis_header.dart';
import '../widgets/analysis/analysis_info_box.dart';
import '../widgets/analysis/analysis_form.dart';
import '../widgets/analysis/analysis_result_sheet.dart';

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

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _muacController.dispose();
    super.dispose();
  }

  Future<void> _analyzeData() async {
    if (_ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _muacController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi semua kolom terlebih dahulu'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final ageMonths = int.tryParse(_ageController.text.trim());
    final weightKg = double.tryParse(_weightController.text.trim());
    final heightCm = double.tryParse(_heightController.text.trim());
    final muacCm = double.tryParse(_muacController.text.trim());

    if (ageMonths == null || weightKg == null || heightCm == null || muacCm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan angka yang valid pada semua kolom'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    try {
      final user = await AuthService.instance.getSavedUser();
      final childId = await ChildService.instance.getActiveChildId();

      if (user == null || childId == null) {
        if (!mounted) return;
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih profil anak terlebih dahulu.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final result = await NutritionAiService.instance.analyzeNutrition(
        NutritionAnalysisRequest(
          ageMonths: ageMonths,
          gender: _selectedGender,
          weightKg: weightKg,
          heightCm: heightCm,
          muacCm: muacCm,
          userId: user.id,
          childId: childId,
        ),
      );

      if (!mounted) return;
      setState(() => _isAnalyzing = false);

      AnalysisResultSheet.show(
        context,
        status: _localizeStatus(result.status),
        recommendation: result.recommendation,
        color: _mapStatusColor(result.status),
        foodSummary: result.foodSummary,
        foodItems: result.foodItems,
      );
    } on NutritionAiException catch (error) {
      if (!mounted) return;
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  String _localizeStatus(String status) {
    const labels = <String, String>{
      'severely stunted': 'Sangat Pendek (Severely Stunted)',
      'stunted': 'Pendek (Stunted)',
      'normal': 'Normal',
      'tinggi': 'Tinggi',
    };
    return labels[status.toLowerCase()] ?? status;
  }

  Color _mapStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
      case 'tinggi':
        return const Color(0xFF4CAF82);
      case 'stunted':
        return Colors.orange;
      case 'severely stunted':
        return Colors.redAccent;
      default:
        return Colors.orange;
    }
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
                onGenderChanged: (value) => setState(() => _selectedGender = value),
                isAnalyzing: _isAnalyzing,
                onAnalyze: _analyzeData,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
