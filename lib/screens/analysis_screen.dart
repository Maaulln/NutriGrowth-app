import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/child_model.dart';
import '../core/providers/analysis_provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/providers/child_provider.dart';
import '../core/providers/navigation_provider.dart';
import '../widgets/analysis/analysis_header.dart';
import '../widgets/analysis/analysis_info_box.dart';
import '../widgets/analysis/analysis_form.dart';
import '../widgets/analysis/analysis_result_sheet.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _muacController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  int? _lastTemplateChildId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyTemplateFromActiveChild();
    });
  }

  /// Mengisi form analisis dari profil anak aktif agar user hanya perlu validasi.
  void _applyTemplateFromActiveChild() {
    final child = ref.read(childrenProvider).activeChild;
    if (child == null || child.id == null) return;
    if (_lastTemplateChildId == child.id) return;

    _fillFormFromChild(child);
    _lastTemplateChildId = child.id;
  }

  void _fillFormFromChild(Child child) {
    _ageController.text = '${child.ageInMonths}';

    if (child.weightKg != null) {
      _weightController.text = child.weightKg!.toStringAsFixed(1);
    } else {
      _weightController.clear();
    }

    if (child.heightCm != null) {
      _heightController.text = child.heightCm!.toStringAsFixed(1);
    } else {
      _heightController.clear();
    }

    if (child.muacCm != null) {
      _muacController.text = child.muacCm!.toStringAsFixed(1);
    } else {
      _muacController.clear();
    }

    if (child.allergies.isNotEmpty) {
      _allergiesController.text = child.allergies.join(', ');
    } else {
      _allergiesController.clear();
    }

    final notifier = ref.read(analysisProvider.notifier);
    notifier.setGender(child.isMale ? 1 : 0);
    notifier.setBreastfeeding(child.exclusiveBreastfeeding);
    notifier.setSupplement(child.supplementIntake);
    notifier.setIllness(child.illnessFrequency);
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _muacController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  List<String> get _allergies => _allergiesController.text
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  Future<void> _analyzeData() async {
    if (_ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _heightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please fill in age, weight, and height first'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final ageMonths = int.tryParse(_ageController.text.trim());
    final weightKg = double.tryParse(_weightController.text.trim());
    final heightCm = double.tryParse(_heightController.text.trim());
    final muacCm = _muacController.text.trim().isNotEmpty
        ? double.tryParse(_muacController.text.trim())
        : null;

    if (ageMonths == null || weightKg == null || heightCm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter valid numbers'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final user = ref.read(authProvider).user;
    final childId = ref.read(childrenProvider).activeChildId;

    if (user == null || childId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select a child profile first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final result = await ref.read(analysisProvider.notifier).analyze(
      ageMonths: ageMonths,
      userId: user.id,
      childId: childId,
      weightKg: weightKg,
      heightCm: heightCm,
      muacCm: muacCm,
      allergies: _allergies,
    );

    if (!mounted) return;

    final analysisState = ref.read(analysisProvider);
    if (analysisState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(analysisState.error!),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (result != null) {
      AnalysisResultSheet.show(
        context,
        status: _formatStatus(result.status),
        recommendation: result.recommendation,
        color: _mapStatusColor(result.status),
        riskLevel: result.riskLevel,
        riskScore: result.riskScore,
        summary: result.summary,
        analysis: result.analysis,
        warningFlags: result.warningFlags,
        foodSummary: result.foodSummary,
        foodItems: result.foodItems,
      );
    }
  }

  String _formatStatus(String status) {
    const labels = <String, String>{
      'severely stunted': 'Severely Stunted',
      'stunted': 'Stunted',
      'normal': 'Normal',
      'tinggi': 'Tall',
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
    final analysisState = ref.watch(analysisProvider);
    final childrenState = ref.watch(childrenProvider);
    final activeChild = childrenState.activeChild;

    ref.listen<ChildrenState>(childrenProvider, (previous, next) {
      final activeIdChanged = previous?.activeChildId != next.activeChildId;
      final childrenJustLoaded =
          (previous?.children.isEmpty ?? true) && next.children.isNotEmpty;

      if (activeIdChanged || childrenJustLoaded) {
        _lastTemplateChildId = null;
        _applyTemplateFromActiveChild();
      }
    });

    ref.listen<int>(navigationIndexProvider, (previous, next) {
      if (next == 1 && previous != 1) {
        _lastTemplateChildId = null;
        _applyTemplateFromActiveChild();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F4),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AnalysisHeader(),
              AnalysisInfoBox(childName: activeChild?.name),
              const SizedBox(height: 24),
              AnalysisForm(
                ageController: _ageController,
                weightController: _weightController,
                heightController: _heightController,
                muacController: _muacController,
                allergiesController: _allergiesController,
                selectedGender: analysisState.selectedGender,
                onGenderChanged: (v) =>
                    ref.read(analysisProvider.notifier).setGender(v),
                exclusiveBreastfeeding: analysisState.exclusiveBreastfeeding,
                onBreastfeedingChanged: (v) =>
                    ref.read(analysisProvider.notifier).setBreastfeeding(v),
                supplementIntake: analysisState.supplementIntake,
                onSupplementChanged: (v) =>
                    ref.read(analysisProvider.notifier).setSupplement(v),
                illnessFrequency: analysisState.illnessFrequency,
                onIllnessChanged: (v) =>
                    ref.read(analysisProvider.notifier).setIllness(v),
                isAnalyzing: analysisState.isAnalyzing,
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
