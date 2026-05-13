import 'package:flutter/material.dart';
import '../custom_input_field.dart';

class AnalysisForm extends StatelessWidget {
  final TextEditingController ageController;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final TextEditingController muacController;
  final int selectedGender;
  final ValueChanged<int> onGenderChanged;
  final bool isAnalyzing;
  final Future<void> Function() onAnalyze;

  const AnalysisForm({
    super.key,
    required this.ageController,
    required this.weightController,
    required this.heightController,
    required this.muacController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.isAnalyzing,
    required this.onAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF4CAF82).withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              initialValue: selectedGender,
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Male')),
                DropdownMenuItem(value: 0, child: Text('Female')),
              ],
              onChanged: isAnalyzing
                  ? null
                  : (value) {
                      if (value != null) {
                        onGenderChanged(value);
                      }
                    },
            ),
            const SizedBox(height: 16),
            CustomInputField(
              controller: ageController,
              icon: Icons.child_care_rounded,
              label: 'Age',
              unit: '(months)',
              placeholder: 'e.g. 18',
            ),
            const SizedBox(height: 16),
            CustomInputField(
              controller: weightController,
              icon: Icons.monitor_weight_outlined,
              label: 'Weight',
              unit: '(kg)',
              placeholder: 'e.g. 10.2',
            ),
            const SizedBox(height: 16),
            CustomInputField(
              controller: heightController,
              icon: Icons.height_rounded,
              label: 'Height',
              unit: '(cm)',
              placeholder: 'e.g. 78.5',
            ),
            const SizedBox(height: 16),
            CustomInputField(
              controller: muacController,
              icon: Icons.accessibility_new_rounded,
              label: 'MUAC',
              unit: '(cm)',
              placeholder: 'e.g. 13.2',
            ),
            const SizedBox(height: 24),
            // Analyze Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isAnalyzing
                    ? null
                    : () async {
                        await onAnalyze();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF82),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isAnalyzing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Analyze Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
