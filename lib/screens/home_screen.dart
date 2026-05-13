import 'package:flutter/material.dart';
import '../core/models/child_model.dart';
import '../core/services/child_service.dart';
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
  Child? _activeChild;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActiveChild();
  }

  Future<void> _loadActiveChild() async {
    try {
      final children = await ChildService.instance.getChildren();
      if (children.isNotEmpty) {
        final activeChildId = await ChildService.instance.getActiveChildId();
        Child? selectedChild;
        if (activeChildId != null) {
          for (final item in children) {
            if (item.id == activeChildId) {
              selectedChild = item;
              break;
            }
          }
        }
        final activeChild = selectedChild ?? children.first;

        if (activeChild.id != null) {
          await ChildService.instance.setActiveChildId(activeChild.id!);
        }

        setState(() {
          _activeChild = activeChild;
          _isLoading = false;
        });
      } else {
        await ChildService.instance.clearActiveChildId();
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9), // Lighter, cleaner background
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
                    const HomeHeader(),
                    const SizedBox(height: 32),
                    const DailyTipCard(),
                    const SizedBox(height: 32),
                    if (_activeChild != null)
                      ChildProfileCard(
                        child: _activeChild!,
                        onChildUpdated: _loadActiveChild,
                      )
                    else
                      _buildAddChildPrompt(),
                    const SizedBox(height: 32),
                    const WeightTrendCard(),
                    const SizedBox(height: 32),
                    const WeeklyNutritionCard(),
                    const SizedBox(height: 32),
                    _buildSectionTitle('LAST CHECK-UP'),
                    const SizedBox(height: 16),
                    const LastCheckupCard(),
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
