import 'package:flutter/material.dart';
import '../custom_input_field.dart';

class AnalysisForm extends StatelessWidget {
  final TextEditingController ageController;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final TextEditingController muacController;
  final TextEditingController allergiesController;
  final int selectedGender;
  final ValueChanged<int> onGenderChanged;
  final bool exclusiveBreastfeeding;
  final ValueChanged<bool> onBreastfeedingChanged;
  final String supplementIntake;
  final ValueChanged<String> onSupplementChanged;
  final String illnessFrequency;
  final ValueChanged<String> onIllnessChanged;
  final bool isAnalyzing;
  final Future<void> Function() onAnalyze;

  const AnalysisForm({
    super.key,
    required this.ageController,
    required this.weightController,
    required this.heightController,
    required this.muacController,
    required this.allergiesController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.exclusiveBreastfeeding,
    required this.onBreastfeedingChanged,
    required this.supplementIntake,
    required this.onSupplementChanged,
    required this.illnessFrequency,
    required this.onIllnessChanged,
    required this.isAnalyzing,
    required this.onAnalyze,
  });

  static const _green = Color(0xFF4CAF82);
  static const _border = Color(0xFFE8F5EE);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _green.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Child Data'),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: selectedGender,
              decoration: _inputDeco('Gender'),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Male')),
                DropdownMenuItem(value: 0, child: Text('Female')),
              ],
              onChanged: isAnalyzing
                  ? null
                  : (v) { if (v != null) onGenderChanged(v); },
            ),
            const SizedBox(height: 14),
            CustomInputField(
              controller: ageController,
              icon: Icons.child_care_rounded,
              label: 'Age',
              unit: '(months)',
              placeholder: 'e.g. 18',
            ),
            const SizedBox(height: 14),
            CustomInputField(
              controller: weightController,
              icon: Icons.monitor_weight_outlined,
              label: 'Weight',
              unit: '(kg)',
              placeholder: 'e.g. 10.2',
            ),
            const SizedBox(height: 14),
            CustomInputField(
              controller: heightController,
              icon: Icons.height_rounded,
              label: 'Height',
              unit: '(cm)',
              placeholder: 'e.g. 78.5',
            ),
            const SizedBox(height: 14),
            CustomInputField(
              controller: muacController,
              icon: Icons.accessibility_new_rounded,
              label: 'MUAC (optional)',
              unit: '(cm)',
              placeholder: 'e.g. 13.2',
            ),

            const SizedBox(height: 20),
            _divider(),
            const SizedBox(height: 16),

            _sectionTitle('Nutrition History'),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Exclusive Breastfeeding (0–6 months)',
                  style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
                ),
                Switch(
                  value: exclusiveBreastfeeding,
                  onChanged: isAnalyzing ? null : onBreastfeedingChanged,
                  activeColor: _green,
                ),
              ],
            ),
            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              value: supplementIntake,
              decoration: _inputDeco('Supplements / Vitamins'),
              items: const [
                DropdownMenuItem(value: 'regular',   child: Text('Regular')),
                DropdownMenuItem(value: 'irregular', child: Text('Irregular')),
                DropdownMenuItem(value: 'none',      child: Text('None')),
              ],
              onChanged: isAnalyzing ? null : (v) { if (v != null) onSupplementChanged(v); },
            ),
            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              value: illnessFrequency,
              decoration: _inputDeco('Illness Frequency'),
              items: const [
                DropdownMenuItem(value: 'low',    child: Text('Low')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'high',   child: Text('High')),
              ],
              onChanged: isAnalyzing ? null : (v) { if (v != null) onIllnessChanged(v); },
            ),

            const SizedBox(height: 20),
            _divider(),
            const SizedBox(height: 16),

            _sectionTitle('Allergies (Optional)'),
            const SizedBox(height: 12),
            TextFormField(
              controller: allergiesController,
              enabled: !isAnalyzing,
              decoration: _inputDeco('e.g. milk, egg, fish').copyWith(
                prefixIcon: const Icon(Icons.warning_amber_rounded, color: _green),
                helperText: 'Separate with commas',
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isAnalyzing ? null : () async { await onAnalyze(); },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
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
                          Icon(Icons.analytics_outlined, size: 18, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Analyze Now',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: _green,
          letterSpacing: 0.4,
        ),
      );

  Widget _divider() => Container(
        height: 1,
        color: _border,
      );

  InputDecoration _inputDeco(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _green, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      );
}
