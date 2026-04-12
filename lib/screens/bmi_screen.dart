import 'package:flutter/material.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  double? bmi;
  String category = "";
  Color categoryColor = Colors.grey;

  void calculateBMI() {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    if (height == null || weight == null || height == 0) return;

    final h = height / 100;
    final value = weight / (h * h);

    if (value < 18.5) {
      category = "Underweight";
      categoryColor = Colors.blue;
    } else if (value < 25) {
      category = "Normal";
      categoryColor = Colors.green;
    } else if (value < 30) {
      category = "Overweight";
      categoryColor = Colors.orange;
    } else {
      category = "Obese";
      categoryColor = Colors.red;
    }

    setState(() {
      bmi = double.parse(value.toStringAsFixed(1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Height Input
            const Text(
              "Height (cm)",
              style:
                  TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
            ),

            const SizedBox(height: 6),

            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "e.g. 175",
              ),
            ),

            const SizedBox(height: 20),

            // Weight Input
            const Text(
              "Weight (kg)",
              style:
                  TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
            ),

            const SizedBox(height: 6),

            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "e.g. 70",
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calculateBMI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Calculate BMI",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Result
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: bmi == null
                  ? const SizedBox()
                  : Center(
                      child: Column(
                        key: const ValueKey("result"),
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Your BMI Result",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 2,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bmi.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 6),
                                Text(
                                  category,
                                  style: TextStyle(
                                    color: categoryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
