import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'screens/home_screen.dart';
import 'screens/converter_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/bmi_screen.dart';
import 'screens/tasks_screen.dart';

void main() {
  runApp(const SmartUtilityToolkit());
}

class SmartUtilityToolkit extends StatefulWidget {
  const SmartUtilityToolkit({super.key});

  @override
  State<SmartUtilityToolkit> createState() => _SmartUtilityToolkitState();
}

class _SmartUtilityToolkitState extends State<SmartUtilityToolkit> {
  int currentIndex = 0;

  late final List<Widget> screens = [
    const HomeScreen(),
    ConverterScreen(onBack: () => setState(() => currentIndex = 0)),
    NotesScreen(onBack: () => setState(() => currentIndex = 0)),
    BmiScreen(onBack: () => setState(() => currentIndex = 0)),
    TasksScreen(onBack: () => setState(() => currentIndex = 0)),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF05014A),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      ),
      home: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),

        // NAV BAR
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF000000).withOpacity(0.65),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 25,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTab(
                        SolarIconsOutline.home, SolarIconsBold.home, 0, "Home"),
                    _buildTab(SolarIconsOutline.refresh, SolarIconsBold.refresh,
                        1, "Convert"),
                    _buildTab(SolarIconsOutline.notes, SolarIconsBold.notes, 2,
                        "Notes"),
                    _buildTab(SolarIconsOutline.heartPulse,
                        SolarIconsBold.heartPulse, 3, "BMI"),
                    _buildTab(SolarIconsOutline.checklistMinimalistic,
                        SolarIconsBold.checklistMinimalistic, 4, "Tasks"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
    IconData activeIcon,
    IconData inactiveIcon,
    int index,
    String label,
  ) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4F46E5).withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.2 : 1.0,
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                color: isSelected ? const Color(0xFF4F46E5) : Colors.white70,
                size: 26,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? const Color(0xFF4F46E5) : Colors.white70,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
