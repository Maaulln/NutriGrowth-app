import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/navigation_provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/providers/child_provider.dart';
import '../widgets/custom_navbar.dart';
import 'home_screen.dart';
import 'analysis_screen.dart';
import 'food_screen.dart';
import 'children_screen.dart';

class MainWrapper extends ConsumerStatefulWidget {
  const MainWrapper({super.key});

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper> {
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = const [
      HomeScreen(),
      AnalysisScreen(),
      FoodScreen(),
      ChildrenScreen(),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = ref.read(authProvider);
      if (auth.user == null) {
        ref.read(authProvider.notifier).loadUser();
      }
      ref.read(childrenProvider.notifier).loadChildren();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F4),
      body: Stack(
        children: [
          IndexedStack(
            index: selectedIndex,
            children: _screens,
          ),
          CustomNavBar(
            selectedIndex: selectedIndex,
            onItemSelected: (i) =>
                ref.read(navigationIndexProvider.notifier).state = i,
          ),
        ],
      ),
    );
  }
}
