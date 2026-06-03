import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/child_model.dart';
import '../services/child_service.dart';

class ChildrenState {
  final List<Child> children;
  final int? activeChildId;
  final bool isLoading;
  final String? error;

  const ChildrenState({
    this.children = const [],
    this.activeChildId,
    this.isLoading = false,
    this.error,
  });

  Child? get activeChild {
    if (activeChildId == null || children.isEmpty) return null;
    return children.firstWhere(
      (c) => c.id == activeChildId,
      orElse: () => children.first,
    );
  }

  ChildrenState copyWith({
    List<Child>? children,
    int? activeChildId,
    bool clearActiveChildId = false,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ChildrenState(
      children: children ?? this.children,
      activeChildId: clearActiveChildId ? null : (activeChildId ?? this.activeChildId),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ChildrenNotifier extends StateNotifier<ChildrenState> {
  ChildrenNotifier() : super(const ChildrenState());

  /// Memuat daftar anak dari backend.
  ///
  /// [force] true memaksa reload meski data sudah ada (mis. pull-to-refresh).
  Future<void> loadChildren({bool force = false}) async {
    if (!force) {
      if (state.isLoading) return;
      if (state.children.isNotEmpty) return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final children = await ChildService.instance.getChildren();
      final storedActiveId = await ChildService.instance.getActiveChildId();

      int? resolvedActiveId = storedActiveId;
      final hasStoredActive = children.any((c) => c.id == storedActiveId);

      if (!hasStoredActive) {
        resolvedActiveId = children.isNotEmpty ? children.first.id : null;
        if (resolvedActiveId != null) {
          await ChildService.instance.setActiveChildId(resolvedActiveId);
        } else {
          await ChildService.instance.clearActiveChildId();
        }
      }

      state = ChildrenState(children: children, activeChildId: resolvedActiveId);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setActiveChild(int childId) async {
    await ChildService.instance.setActiveChildId(childId);
    state = state.copyWith(activeChildId: childId);
  }

  Future<void> refresh() => loadChildren(force: true);
}

final childrenProvider = StateNotifierProvider<ChildrenNotifier, ChildrenState>(
  (ref) => ChildrenNotifier(),
);
