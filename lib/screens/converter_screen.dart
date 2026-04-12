import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import '../services/converter_service.dart';

enum ConversionType { length, weight, temperature }

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController controller = TextEditingController();

  ConversionType type = ConversionType.length;

  double result = 0;

  void calculate() {
    final value = double.tryParse(controller.text);

    if (value == null) return;

    switch (type) {
      case ConversionType.length:
        result = ConverterService.metersToFeet(value);
        break;

      case ConversionType.weight:
        result = ConverterService.kgToPounds(value);
        break;

      case ConversionType.temperature:
        result = ConverterService.celsiusToFahrenheit(value);
        break;
    }

    setState(() {});
  }

  String getFromUnit() {
    switch (type) {
      case ConversionType.length:
        return "meters";
      case ConversionType.weight:
        return "kg";
      case ConversionType.temperature:
        return "°C";
    }
  }

  String getToUnit() {
    switch (type) {
      case ConversionType.length:
        return "feet";
      case ConversionType.weight:
        return "pounds";
      case ConversionType.temperature:
        return "°F";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Unit Converter",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _typeButton(
                    icon: SolarIconsOutline.ruler,
                    label: "Length",
                    selected: type == ConversionType.length,
                    onTap: () {
                      setState(() => type = ConversionType.length);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _typeButton(
                    icon: SolarIconsOutline.dumbbell,
                    label: "Weight",
                    selected: type == ConversionType.weight,
                    onTap: () {
                      setState(() => type = ConversionType.weight);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _typeButton(
                    icon: SolarIconsOutline.temperature,
                    label: "Temp",
                    selected: type == ConversionType.temperature,
                    onTap: () {
                      setState(() => type = ConversionType.temperature);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "Value in ${getFromUnit()}",
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              onChanged: (v) => calculate(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter value...",
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Result",
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey(result),
                height: 56,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  "${result.toStringAsFixed(2)} ${getToUnit()}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _typeButton({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4F46E5) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
