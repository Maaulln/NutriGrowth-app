import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF9), // Lighter, cleaner background
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
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
              const ChildProfileCard(),
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
