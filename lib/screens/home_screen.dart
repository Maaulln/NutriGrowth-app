import 'package:flutter/material.dart';
import '../core/models/child_model.dart';
import '../core/models/growth_record_model.dart';
import '../core/models/stunting_assessment_model.dart';
import '../core/models/user_model.dart';
import '../core/services/auth_service.dart';
import '../core/services/child_service.dart';
import '../core/services/nutrition_ai_service.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/daily_tip_card.dart';
import '../widgets/home/child_profile_card.dart';
import '../widgets/home/weight_trend_card.dart';
import '../widgets/home/weekly_nutrition_card.dart';
import '../widgets/home/last_checkup_card.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const HomeScreen({super.key, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? _user;
  Child? _activeChild;
  List<GrowthRecord> _growthRecords = [];
  StuntingAssessmentSummary? _latestAssessment;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        AuthService.instance.getSavedUser(),
        ChildService.instance.getChildren(),
      ]);

      final user = results[0] as UserModel?;
      final children = results[1] as List<Child>;

      Child? activeChild;
      if (children.isNotEmpty) {
        final activeChildId = await ChildService.instance.getActiveChildId();
        if (activeChildId != null) {
          for (final c in children) {
            if (c.id == activeChildId) {
              activeChild = c;
              break;
            }
          }
        }
        activeChild ??= children.first;
        if (activeChild.id != null) {
          await ChildService.instance.setActiveChildId(activeChild.id!);
        }
      } else {
        await ChildService.instance.clearActiveChildId();
      }

      List<GrowthRecord> growthRecords = [];
      StuntingAssessmentSummary? latestAssessment;

      if (activeChild?.id != null) {
        final extraResults = await Future.wait([
          ChildService.instance.getGrowthRecords(activeChild!.id!),
          NutritionAiService.instance.getLatestAssessment(activeChild.id!),
        ]);
        growthRecords = extraResults[0] as List<GrowthRecord>;
        latestAssessment = extraResults[1] as StuntingAssessmentSummary?;
      }

      if (!mounted) return;
      setState(() {
        _user = user;
        _activeChild = activeChild;
        _growthRecords = growthRecords;
        _latestAssessment = latestAssessment;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9),
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF4CAF82)),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 20,
                  bottom: 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(userName: _user?.name),
                    const SizedBox(height: 32),
                    const DailyTipCard(),
                    const SizedBox(height: 32),
                    if (_activeChild != null)
                      ChildProfileCard(
                        child: _activeChild!,
                        onChildUpdated: _loadData,
                      )
                    else
                      _buildAddChildPrompt(),
                    const SizedBox(height: 32),
                    WeightTrendCard(records: _growthRecords),
                    const SizedBox(height: 32),
                    const WeeklyNutritionCard(),
                    const SizedBox(height: 32),
                    _buildSectionTitle('LAST CHECK-UP'),
                    const SizedBox(height: 16),
                    LastCheckupCard(assessment: _latestAssessment),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildAddChildPrompt() {
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
        children: [
          const Icon(
            Icons.child_care_rounded,
            size: 48,
            color: Color(0xFF4CAF82),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada data anak',
            style: TextStyle(
              color: Color(0xFF1A2E2A),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambah profil anak untuk mulai memantau tumbuh kembangnya.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF6B8F80), fontSize: 13),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => widget.onNavigate?.call(3),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF82),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Tambah Anak'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF86A796),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}
