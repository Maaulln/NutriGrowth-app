import 'package:flutter/material.dart';
import '../core/models/child_model.dart';
import '../core/services/child_service.dart';

class AddChildScreen extends StatefulWidget {
  final Child? initialChild;

  const AddChildScreen({super.key, this.initialChild});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _muacController = TextEditingController();
  final _allergiesController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedGender = 'male';
  bool _exclusiveBreastfeeding = true;
  String _supplementIntake = 'none';
  String _illnessFrequency = 'low';
  bool _isLoading = false;

  bool get _isEditMode => widget.initialChild != null;

  @override
  void initState() {
    super.initState();
    final child = widget.initialChild;
    if (child != null) {
      _nameController.text = child.name;
      _selectedGender = child.gender;
      _selectedDate = child.birthDate;
      if (child.weightKg != null) {
        _weightController.text = child.weightKg!.toStringAsFixed(1);
      }
      if (child.heightCm != null) {
        _heightController.text = child.heightCm!.toStringAsFixed(1);
      }
      if (child.muacCm != null) {
        _muacController.text = child.muacCm!.toStringAsFixed(1);
      }
      if (child.allergies.isNotEmpty) {
        _allergiesController.text = child.allergies.join(', ');
      }
      _exclusiveBreastfeeding = child.exclusiveBreastfeeding;
      _supplementIntake = child.supplementIntake;
      _illnessFrequency = child.illnessFrequency;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _muacController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  /// Memvalidasi input numerik opsional lalu mengembalikannya sebagai `double?`.
  double? _parseMetric(String rawValue) {
    final value = rawValue.trim();
    if (value.isEmpty) {
      return null;
    }
    return double.tryParse(value);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime.now().subtract(
        const Duration(days: 365 * 6),
      ), // Max 6 years
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF4CAF82)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date of birth')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final weightKg = _parseMetric(_weightController.text);
      final heightCm = _parseMetric(_heightController.text);
      final muacCm = _parseMetric(_muacController.text);

      if ((_weightController.text.trim().isNotEmpty && weightKg == null) ||
          (_heightController.text.trim().isNotEmpty && heightCm == null) ||
          (_muacController.text.trim().isNotEmpty && muacCm == null)) {
        throw Exception('Weight, height, and MUAC must be valid numbers.');
      }

      final allergies = _allergiesController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final child = Child(
        id: widget.initialChild?.id,
        userId: widget.initialChild?.userId ?? 0,
        name: _nameController.text.trim(),
        gender: _selectedGender,
        birthDate: _selectedDate!,
        weightKg: weightKg,
        heightCm: heightCm,
        muacCm: muacCm,
        allergies: allergies,
        exclusiveBreastfeeding: _exclusiveBreastfeeding,
        supplementIntake: _supplementIntake,
        illnessFrequency: _illnessFrequency,
      );

      final savedChild = _isEditMode
          ? await ChildService.instance.updateChild(
              widget.initialChild!.id!,
              child,
            )
          : await ChildService.instance.addChild(child);

      if (mounted) {
        Navigator.pop(context, savedChild);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Child data updated successfully'
                  : 'Child data added successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final message = e is Exception
            ? e.toString().replaceFirst('Exception: ', '')
            : 'An error occurred, please try again';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Child' : 'Add Child'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1A2E2A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Child Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2E2A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete the information below to monitor your child\'s growth.',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              // Nama
              const Text(
                'Full Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Ahmad Fauzan',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name cannot be empty' : null,
              ),
              const SizedBox(height: 20),

              // Gender
              const Text(
                'Gender',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildGenderOption('male', 'Male', Icons.boy),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGenderOption(
                      'female',
                      'Female',
                      Icons.girl,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Tanggal Lahir
              const Text(
                'Date of Birth',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF4CAF82),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(
                          color: _selectedDate == null
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Weight (kg)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. 12.5',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Height (cm)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _heightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. 89.0',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'MUAC (cm)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _muacController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. 14.2',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 28),
              const Divider(color: Color(0xFFE8F5EE)),
              const SizedBox(height: 20),

              const Text(
                'Nutrition History',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4CAF82),
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Exclusive Breastfeeding (0–6 months)',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Switch(
                    value: _exclusiveBreastfeeding,
                    onChanged: (v) =>
                        setState(() => _exclusiveBreastfeeding = v),
                    activeThumbColor: const Color(0xFF4CAF82),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                'Supplements / Vitamins',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildDropdown<String>(
                value: _supplementIntake,
                items: const [
                  DropdownMenuItem(value: 'regular', child: Text('Regular')),
                  DropdownMenuItem(value: 'irregular', child: Text('Irregular')),
                  DropdownMenuItem(value: 'none', child: Text('None')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _supplementIntake = v);
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Illness Frequency',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildDropdown<String>(
                value: _illnessFrequency,
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Low')),
                  DropdownMenuItem(value: 'medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'high', child: Text('High')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _illnessFrequency = v);
                },
              ),

              const SizedBox(height: 20),
              const Divider(color: Color(0xFFE8F5EE)),
              const SizedBox(height: 20),

              const Text(
                'Allergies (Optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4CAF82),
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _allergiesController,
                decoration: InputDecoration(
                  hintText: 'e.g. milk, egg, fish',
                  helperText: 'Separate with commas',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFF4CAF82),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF82),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isEditMode ? 'Update Child' : 'Save Child',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = _selectedGender == value;
    return InkWell(
      onTap: () => setState(() => _selectedGender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4CAF82).withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF82) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF4CAF82) : Colors.grey,
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF4CAF82) : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
