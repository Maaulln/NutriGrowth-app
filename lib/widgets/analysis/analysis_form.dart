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
            // ── Data Antropometri ──────────────────────────────────────────
            _sectionTitle('Data Anak'),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: selectedGender,
              decoration: _inputDeco('Jenis Kelamin'),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Laki-laki')),
                DropdownMenuItem(value: 0, child: Text('Perempuan')),
              ],
              onChanged: isAnalyzing
                  ? null
                  : (v) { if (v != null) onGenderChanged(v); },
            ),
            const SizedBox(height: 14),
            CustomInputField(
              controller: ageController,
              icon: Icons.child_care_rounded,
              label: 'Usia',
              unit: '(bulan)',
              placeholder: 'cth. 18',
            ),
            const SizedBox(height: 14),
            CustomInputField(
              controller: weightController,
              icon: Icons.monitor_weight_outlined,
              label: 'Berat Badan',
              unit: '(kg)',
              placeholder: 'cth. 10.2',
            ),
            const SizedBox(height: 14),
            CustomInputField(
              controller: heightController,
              icon: Icons.height_rounded,
              label: 'Tinggi Badan',
              unit: '(cm)',
              placeholder: 'cth. 78.5',
            ),
            const SizedBox(height: 14),
            CustomInputField(
              controller: muacController,
              icon: Icons.accessibility_new_rounded,
              label: 'MUAC (opsional)',
              unit: '(cm)',
              placeholder: 'cth. 13.2',
            ),

            const SizedBox(height: 20),
            _divider(),
            const SizedBox(height: 16),

            // ── Riwayat Gizi ───────────────────────────────────────────────
            _sectionTitle('Riwayat Gizi'),
            const SizedBox(height: 12),

            // ASI Eksklusif
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ASI Eksklusif (0–6 bulan)',
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

            // Suplemen
            DropdownButtonFormField<String>(
              value: supplementIntake,
              decoration: _inputDeco('Suplemen / Vitamin'),
              items: const [
                DropdownMenuItem(value: 'regular',   child: Text('Rutin')),
                DropdownMenuItem(value: 'irregular', child: Text('Tidak Rutin')),
                DropdownMenuItem(value: 'none',      child: Text('Tidak Ada')),
              ],
              onChanged: isAnalyzing ? null : (v) { if (v != null) onSupplementChanged(v); },
            ),
            const SizedBox(height: 14),

            // Frekuensi sakit
            DropdownButtonFormField<String>(
              value: illnessFrequency,
              decoration: _inputDeco('Frekuensi Sakit'),
              items: const [
                DropdownMenuItem(value: 'low',    child: Text('Rendah')),
                DropdownMenuItem(value: 'medium', child: Text('Sedang')),
                DropdownMenuItem(value: 'high',   child: Text('Tinggi')),
              ],
              onChanged: isAnalyzing ? null : (v) { if (v != null) onIllnessChanged(v); },
            ),

            const SizedBox(height: 20),
            _divider(),
            const SizedBox(height: 16),

            // ── Alergi ────────────────────────────────────────────────────
            _sectionTitle('Alergi (Opsional)'),
            const SizedBox(height: 12),
            TextFormField(
              controller: allergiesController,
              enabled: !isAnalyzing,
              decoration: _inputDeco('cth. susu, telur, ikan').copyWith(
                prefixIcon: const Icon(Icons.warning_amber_rounded, color: _green),
                helperText: 'Pisahkan dengan koma',
              ),
            ),

            const SizedBox(height: 24),

            // ── Tombol Analisis ────────────────────────────────────────────
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
                            'Analisis Sekarang',
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
