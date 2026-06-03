import 'package:flutter/material.dart';
import '../notification_button.dart';

class HomeHeader extends StatelessWidget {
  final String? userName;

  const HomeHeader({super.key, this.userName});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 15) return 'Good afternoon,';
    if (hour < 18) return 'Good evening,';
    return 'Good night,';
  }

  @override
  Widget build(BuildContext context) {
    final displayName = (userName != null && userName!.isNotEmpty)
        ? userName!
        : 'Parent';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _greeting,
              style: const TextStyle(
                color: Color(0xFF86A796),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              displayName,
              style: const TextStyle(
                color: Color(0xFF1A2E2A),
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const NotificationButton(),
      ],
    );
  }
}
