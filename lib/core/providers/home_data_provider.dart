import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/growth_record_model.dart';
import '../models/stunting_assessment_model.dart';
import '../services/child_service.dart';
import '../services/nutrition_ai_service.dart';
import 'child_provider.dart';

class HomeScreenData {
  final List<GrowthRecord> growthRecords;
  final List<StuntingAssessmentSummary> assessments;

  const HomeScreenData({
    required this.growthRecords,
    required this.assessments,
  });

  StuntingAssessmentSummary? get latestAssessment =>
      assessments.isNotEmpty ? assessments.last : null;
}

final homeDataProvider = FutureProvider.autoDispose<HomeScreenData>((ref) async {
  final activeChild = ref.watch(
    childrenProvider.select((state) => state.activeChild),
  );
  if (activeChild?.id == null) {
    return const HomeScreenData(growthRecords: [], assessments: []);
  }

  final results = await Future.wait([
    ChildService.instance.getGrowthRecords(activeChild!.id!),
    NutritionAiService.instance.getAllAssessments(activeChild.id!),
  ]);

  return HomeScreenData(
    growthRecords: results[0] as List<GrowthRecord>,
    assessments: results[1] as List<StuntingAssessmentSummary>,
  );
});
