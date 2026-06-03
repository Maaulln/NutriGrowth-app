import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/child_model.dart';
import '../core/providers/child_provider.dart';
import 'add_child_screen.dart';
import 'child_profile_screen.dart';

class ChildrenScreen extends ConsumerWidget {
  const ChildrenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(childrenProvider);

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
                MaterialPageRoute(
                    builder: (context) => const AddChildScreen()),
              );
              if (result is Child) {
                ref.read(childrenProvider.notifier).loadChildren();
              }
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF4CAF82),
            ),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4CAF82)),
            )
          : state.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(state.error!),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(childrenProvider.notifier).loadChildren(),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : state.children.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.child_care,
                              size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada data anak',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddChildScreen(),
                                ),
                              );
                              if (result is Child) {
                                ref
                                    .read(childrenProvider.notifier)
                                    .loadChildren();
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
                      itemCount: state.children.length,
                      itemBuilder: (context, index) {
                        return _buildChildCard(
                            context, ref, state.children[index],
                            state.activeChildId);
                      },
                    ),
    );
  }

  Widget _buildChildCard(
    BuildContext context,
    WidgetRef ref,
    Child child,
    int? activeChildId,
  ) {
    final isMale = child.isMale;
    final isActiveChild = child.id != null && child.id == activeChildId;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChildProfileScreen(child: child),
          ),
        );
        if (result == true) {
          ref.read(childrenProvider.notifier).loadChildren();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActiveChild
                ? const Color(0xFF4CAF82)
                : Colors.transparent,
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
                    style:
                        TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  if (isActiveChild) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF82)
                            .withValues(alpha: 0.12),
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
              onPressed: () async {
                if (child.id == null) return;
                await ref
                    .read(childrenProvider.notifier)
                    .setActiveChild(child.id!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('${child.name} dipilih sebagai anak aktif.'),
                      backgroundColor: const Color(0xFF2E8B57),
                    ),
                  );
                }
              },
              icon: Icon(
                isActiveChild
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                size: 22,
                color: isActiveChild
                    ? const Color(0xFF2E8B57)
                    : Colors.grey,
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
                    builder: (context) =>
                        AddChildScreen(initialChild: child),
                  ),
                );
                if (result is Child) {
                  ref.read(childrenProvider.notifier).loadChildren();
                }
              },
              icon: const Icon(Icons.edit_outlined,
                  size: 18, color: Colors.grey),
            ),
            IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChildProfileScreen(child: child),
                  ),
                );
                if (result == true) {
                  ref.read(childrenProvider.notifier).loadChildren();
                }
              },
              icon: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
