import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';
import 'home_screen.dart';
import 'analysis_screen.dart';
import 'food_screen.dart';
import 'children_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  List<Widget> get _screens => [
    HomeScreen(onNavigate: _onNavigate),
    AnalysisScreen(onNavigate: _onNavigate),
    FoodScreen(onNavigate: _onNavigate, isActive: _selectedIndex == 2),
    ChildrenScreen(isActive: _selectedIndex == 3),
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
