import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';
import 'api_service.dart';
import 'auth_service.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final _client = http.Client();

  Future<Map<String, String>> _authHeaders() async {
    final token = await AuthService.instance.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<NotificationResponse> fetchNotifications() async {
    final uri = Uri.parse('${ApiService.baseUrl}/notifications');
    final response = await _client
        .get(uri, headers: await _authHeaders())
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final list = json['data'] as List? ?? [];
      return NotificationResponse(
        unreadCount: json['unread_count'] as int? ?? 0,
        notifications: list
            .whereType<Map<String, dynamic>>()
            .map(AppNotification.fromJson)
            .toList(),
      );
    }
    return const NotificationResponse(unreadCount: 0, notifications: []);
  }

  Future<void> markAllRead() async {
    final uri = Uri.parse('${ApiService.baseUrl}/notifications/read-all');
    await _client
        .patch(uri, headers: await _authHeaders())
        .timeout(const Duration(seconds: 10));
  }
}
