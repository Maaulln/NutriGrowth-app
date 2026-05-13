import 'package:flutter/material.dart';
import '../core/models/child_model.dart';
import '../core/services/child_service.dart';
import 'add_child_screen.dart';
import 'child_profile_screen.dart';

class ChildrenScreen extends StatefulWidget {
  final bool isActive;
  const ChildrenScreen({super.key, this.isActive = false});

  @override
  State<ChildrenScreen> createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends State<ChildrenScreen> {
  List<Child> _children = [];
  int? _activeChildId;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void didUpdateWidget(ChildrenScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _fetchChildren();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchChildren();
  }

  Future<void> _fetchChildren() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final children = await ChildService.instance.getChildren();
      final storedActiveId = await ChildService.instance.getActiveChildId();
      int? resolvedActiveId = storedActiveId;

      final hasStoredActive = children.any(
        (child) => child.id == storedActiveId,
      );
      if (!hasStoredActive) {
        resolvedActiveId = children.isNotEmpty ? children.first.id : null;
        if (resolvedActiveId != null) {
          await ChildService.instance.setActiveChildId(resolvedActiveId);
        } else {
          await ChildService.instance.clearActiveChildId();
        }
      }

      setState(() {
        _children = children;
        _activeChildId = resolvedActiveId;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Menjadikan [child] sebagai anak aktif pilihan orang tua.
  Future<void> _selectActiveChild(Child child) async {
    if (child.id == null) {
      return;
    }

    await ChildService.instance.setActiveChildId(child.id!);
    if (!mounted) {
      return;
    }

    setState(() {
      _activeChildId = child.id;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${child.name} dipilih sebagai anak aktif.'),
        backgroundColor: const Color(0xFF2E8B57),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: const Text(
          'Profil Anak',
          style: TextStyle(
            color: Color(0xFF1A2E2A),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddChildScreen()),
              );
              if (result is Child) {
                _fetchChildren();
              }
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF4CAF82),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4CAF82)),
            )
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(_errorMessage!),
                  ElevatedButton(
                    onPressed: _fetchChildren,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : _children.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.child_care, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada data anak',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddChildScreen(),
                        ),
                      );
                      if (result is Child) {
                        _fetchChildren();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF82),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Tambah Anak Pertama'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _children.length,
              itemBuilder: (context, index) {
                final child = _children[index];
                return _buildChildCard(child);
              },
            ),
    );
  }

  Widget _buildChildCard(Child child) {
    final isMale = child.isMale;
    final isActiveChild = child.id != null && child.id == _activeChildId;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChildProfileScreen(child: child),
          ),
        );
        if (result == true && mounted) {
          _fetchChildren();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActiveChild ? const Color(0xFF4CAF82) : Colors.transparent,
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isMale ? Colors.blue[50] : Colors.pink[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                isMale ? Icons.boy : Icons.girl,
                size: 40,
                color: isMale ? Colors.blue : Colors.pink,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2E2A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${child.genderLabel} • ${child.ageFormatted}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  if (isActiveChild) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF82).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Anak Aktif',
                        style: TextStyle(
                          color: Color(0xFF2E8B57),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: () => _selectActiveChild(child),
              icon: Icon(
                isActiveChild
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                size: 22,
                color: isActiveChild ? const Color(0xFF2E8B57) : Colors.grey,
              ),
              tooltip: isActiveChild
                  ? 'Sudah menjadi anak aktif'
                  : 'Pilih sebagai anak aktif',
            ),
            IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddChildScreen(initialChild: child),
                  ),
                );
                if (result is Child && mounted) {
                  _fetchChildren();
                }
              },
              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChildProfileScreen(child: child),
                  ),
                );
                if (result == true && mounted) {
                  _fetchChildren();
                }
              },
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
