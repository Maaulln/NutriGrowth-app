import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/auth_provider.dart';
import '../core/providers/child_provider.dart';
import '../core/providers/home_data_provider.dart';
import '../core/providers/navigation_provider.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/daily_tip_card.dart';
import '../widgets/home/child_profile_card.dart';
import '../widgets/home/weight_trend_card.dart';
import '../widgets/home/weekly_nutrition_card.dart';
import '../widgets/home/last_checkup_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final childrenState = ref.watch(childrenProvider);
    final activeChild = childrenState.activeChild;

    final homeDataAsync = childrenState.isLoading
        ? const AsyncValue<HomeScreenData>.loading()
        : ref.watch(homeDataProvider);

    final data = homeDataAsync.valueOrNull;
    final chartsLoading = homeDataAsync.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: const Color(0xFF4CAF82),
          onRefresh: () async {
            await ref.read(childrenProvider.notifier).refresh();
            ref.invalidate(homeDataProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 20,
              bottom: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(userName: authState.user?.name),
                const SizedBox(height: 32),
                const DailyTipCard(),
                const SizedBox(height: 32),
                if (childrenState.isLoading)
                  _buildChildProfileSkeleton()
                else if (activeChild != null)
                  ChildProfileCard(
                    child: activeChild,
                    onChildUpdated: () async {
                      await ref.read(childrenProvider.notifier).refresh();
                      ref.invalidate(homeDataProvider);
                    },
                  )
                else
                  _buildAddChildPrompt(ref),
                const SizedBox(height: 32),
                if (chartsLoading) ...[
                  const LinearProgressIndicator(
                    color: Color(0xFF4CAF82),
                    backgroundColor: Color(0xFFE8F5EE),
                    minHeight: 2,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  const SizedBox(height: 16),
                ],
                WeightTrendCard(records: data?.growthRecords ?? []),
                const SizedBox(height: 32),
                WeeklyNutritionCard(assessments: data?.assessments ?? []),
                const SizedBox(height: 32),
                _buildSectionTitle('LAST CHECK-UP'),
                const SizedBox(height: 16),
                LastCheckupCard(assessment: data?.latestAssessment),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildProfileSkeleton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: const Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Color(0xFFE8F5EE),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 14,
                  width: 120,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFE8F5EE),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 12,
                  width: 80,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFE8F5EE),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddChildPrompt(WidgetRef ref) {
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
            onPressed: () =>
                ref.read(navigationIndexProvider.notifier).state = 3,
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
