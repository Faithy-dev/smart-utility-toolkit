import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:flutter/services.dart';
import '../services/converter_service.dart';

enum ConversionType { length, weight, temperature }

class ConverterScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ConverterScreen({super.key, required this.onBack});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController controller = TextEditingController();

  ConversionType type = ConversionType.length;
  double? result;

  void calculate(String value) {
    final parsed = double.tryParse(value);
    if (parsed == null) {
      setState(() => result = null);
      return;
    }

    double res;

    switch (type) {
      case ConversionType.length:
        res = ConverterService.metersToFeet(parsed);
        break;
      case ConversionType.weight:
        res = ConverterService.kgToPounds(parsed);
        break;
      case ConversionType.temperature:
        res = ConverterService.celsiusToFahrenheit(parsed);
        break;
    }

    setState(() => result = res);
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Unit Converter",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // TYPE SELECTOR
              Row(
                children: [
                  Expanded(
                    child: _typeButton(
                      icon: SolarIconsOutline.ruler,
                      label: "Length",
                      selected: type == ConversionType.length,
                      onTap: () => setState(() => type = ConversionType.length),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _typeButton(
                      icon: SolarIconsOutline.dumbbell,
                      label: "Weight",
                      selected: type == ConversionType.weight,
                      onTap: () => setState(() => type = ConversionType.weight),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _typeButton(
                      icon: SolarIconsOutline.temperature,
                      label: "Temp",
                      selected: type == ConversionType.temperature,
                      onTap: () =>
                          setState(() => type = ConversionType.temperature),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                "Value in ${getFromUnit()}",
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                onChanged: (v) => calculate(v),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter value...",
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Result",
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 10),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey(result),
                  height: 70,
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Text(
                    result == null
                        ? "-- ${getToUnit()}"
                        : "${result!.toStringAsFixed(2)} ${getToUnit()}",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4F46E5) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
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
