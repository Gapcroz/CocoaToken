import 'package:cocoa_token_front/models/coupon_model.dart';

// Enums para los estados y tipos
enum RewardStatus { success, expired }

enum RewardType { vote, attendance, event }

enum CouponStatus { available, locked, used, expired }

class RewardHistory {
  final String id;
  final String title;
  final String subtitle;
  final int tokens;
  final DateTime date;
  final RewardStatus status;
  final RewardType type;

  RewardHistory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tokens,
    required this.date,
    required this.status,
    required this.type,
  });

  factory RewardHistory.fromJson(Map<String, dynamic> json) {
    return RewardHistory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      tokens: json['tokens'] ?? 0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      status: RewardStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => RewardStatus.expired,
      ),
      type: RewardType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => RewardType.event,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'tokens': tokens,
      'date': date.toIso8601String(),
      'status': status.name,
      'type': type.name,
    };
  }

  String get statusText {
    switch (status) {
      case RewardStatus.success:
        return 'Exitosa';
      case RewardStatus.expired:
        return 'Vencida';
    }
  }

  String get typeText {
    switch (type) {
      case RewardType.vote:
        return 'Votación';
      case RewardType.attendance:
        return 'Asistencia';
      case RewardType.event:
        return 'Evento';
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final int tokens;
  final List<RewardHistory> rewardsHistory;
  final List<CouponModel> coupons;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.tokens,
    required this.rewardsHistory,
    required this.coupons,
    required this.role,
  });

  // Gets the initials of first and last name
  String get initials {
    final nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  // Gets the first name
  String get firstName {
    final nameParts = name.trim().split(' ');
    return nameParts.isNotEmpty ? nameParts[0] : '';
  }

  // Gets the last name
  String get lastName {
    final nameParts = name.trim().split(' ');
    return nameParts.length > 1 ? nameParts[1] : '';
  }

  bool get isStore => role == 'store';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      tokens: json['tokens'] ?? 0,
      rewardsHistory:
          (json['rewards_history'] as List?)
              ?.map((e) => RewardHistory.fromJson(e))
              .toList() ??
          [],
      coupons:
          (json['coupons'] as List?)
              ?.map((e) => CouponModel.fromJson(e))
              .toList() ??
          [],
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'tokens': tokens,
      'rewards_history': rewardsHistory.map((r) => r.toJson()).toList(),
      'coupons': coupons.map((c) => c.toJson()).toList(),
      'role': role,
    };
  }
}
