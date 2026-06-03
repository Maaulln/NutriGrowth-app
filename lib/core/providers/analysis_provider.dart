import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/nutrition_analysis_model.dart';
import '../services/nutrition_ai_service.dart';

class AnalysisState {
  final int selectedGender;
  final bool exclusiveBreastfeeding;
  final String supplementIntake;
  final String illnessFrequency;
  final bool isAnalyzing;
  final String? error;

  const AnalysisState({
    this.selectedGender = 1,
    this.exclusiveBreastfeeding = true,
    this.supplementIntake = 'irregular',
    this.illnessFrequency = 'low',
    this.isAnalyzing = false,
    this.error,
  });

  AnalysisState copyWith({
    int? selectedGender,
    bool? exclusiveBreastfeeding,
    String? supplementIntake,
    String? illnessFrequency,
    bool? isAnalyzing,
    String? error,
    bool clearError = false,
  }) {
    return AnalysisState(
      selectedGender: selectedGender ?? this.selectedGender,
      exclusiveBreastfeeding: exclusiveBreastfeeding ?? this.exclusiveBreastfeeding,
      supplementIntake: supplementIntake ?? this.supplementIntake,
      illnessFrequency: illnessFrequency ?? this.illnessFrequency,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AnalysisNotifier extends StateNotifier<AnalysisState> {
  AnalysisNotifier() : super(const AnalysisState());

  void setGender(int gender) => state = state.copyWith(selectedGender: gender);
  void setBreastfeeding(bool v) => state = state.copyWith(exclusiveBreastfeeding: v);
  void setSupplement(String v) => state = state.copyWith(supplementIntake: v);
  void setIllness(String v) => state = state.copyWith(illnessFrequency: v);

  Future<NutritionAnalysisResult?> analyze({
    required int ageMonths,
    required int userId,
    required int childId,
    required double weightKg,
    required double heightCm,
    double? muacCm,
    List<String> allergies = const [],
  }) async {
    state = state.copyWith(isAnalyzing: true, clearError: true);
    try {
      final result = await NutritionAiService.instance.analyzeNutrition(
        NutritionAnalysisRequest(
          ageMonths: ageMonths,
          gender: state.selectedGender,
          weightKg: weightKg,
          heightCm: heightCm,
          muacCm: muacCm,
          userId: userId,
          childId: childId,
          allergies: allergies,
          exclusiveBreastfeeding: state.exclusiveBreastfeeding,
          supplementIntake: state.supplementIntake,
          illnessFrequency: state.illnessFrequency,
        ),
      );
      state = state.copyWith(isAnalyzing: false);
      return result;
    } on NutritionAiException catch (e) {
      state = state.copyWith(isAnalyzing: false, error: e.message);
      return null;
    } catch (e) {
      state = state.copyWith(isAnalyzing: false, error: e.toString());
      return null;
    }
  }
}

final analysisProvider = StateNotifierProvider<AnalysisNotifier, AnalysisState>(
  (ref) => AnalysisNotifier(),
);
