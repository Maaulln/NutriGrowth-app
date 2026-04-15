import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';
import 'home_screen.dart';
import 'analysis_screen.dart';
import 'food_screen.dart';
import 'photo_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    HomeScreen(onNavigate: _onNavigate),
    AnalysisScreen(onNavigate: _onNavigate),
    FoodScreen(onNavigate: _onNavigate),
    PhotoScreen(onNavigate: _onNavigate),
  ];

  void _onNavigate(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F4),
      body: Stack(
        children: [
          _screens[_selectedIndex],
          CustomNavBar(
            selectedIndex: _selectedIndex,
            onItemSelected: _onNavigate,
          ),
        ],
      ),
    );
  }
}
