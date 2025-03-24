import 'dart:convert';

class RewardHistory {
  static const String STATUS_SUCCESS = 'success';
  static const String STATUS_EXPIRED = 'expired';
  static const String TYPE_VOTE = 'vote';
  static const String TYPE_ATTENDANCE = 'attendance';
  static const String TYPE_EVENT = 'event';

  final String id;
  final String title;
  final String subtitle;
  final int tokens;
  final DateTime date;
  final String status;
  final String type;

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
      status: json['status'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'tokens': tokens,
      'date': date.toIso8601String(),
      'status': status,
      'type': type,
    };
  }

  String get statusText {
    switch (status) {
      case STATUS_SUCCESS:
        return 'Exitosa';
      case STATUS_EXPIRED:
        return 'Vencida';
      default:
        return 'Desconocido';
    }
  }

  String get typeText {
    switch (type) {
      case TYPE_VOTE:
        return 'Votación';
      case TYPE_ATTENDANCE:
        return 'Asistencia';
      case TYPE_EVENT:
        return 'Evento';
      default:
        return 'Otro';
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
  final List<Coupon> coupons;
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Extracción de recompensas
    List<RewardHistory> rewards = [];
    if (json['rewards_history'] != null) {
      rewards = (json['rewards_history'] as List)
          .map((rewardJson) => RewardHistory.fromJson(rewardJson))
          .toList();
    }

    // Extracción de cupones
    List<Coupon> userCoupons = [];
    if (json['coupons'] != null) {
      userCoupons = (json['coupons'] as List)
          .map((couponJson) => Coupon.fromJson(couponJson))
          .toList();
    }

    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      tokens: json['tokens'] ?? 0,
      rewardsHistory: rewards,
      coupons: userCoupons,
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
      'rewards_history': rewardsHistory.map((reward) => reward.toJson()).toList(),
      'coupons': coupons.map((coupon) => coupon.toJson()).toList(),
      'role': role,
    };
  }
}

class Coupon {
  static const String STATUS_AVAILABLE = 'available';
  static const String STATUS_LOCKED = 'locked';

  final String id;
  final String name;
  final String description;
  final int tokensRequired;
  final DateTime validUntil;
  final String status;

  Coupon({
    required this.id,
    required this.name,
    required this.description,
    required this.tokensRequired,
    required this.validUntil,
    required this.status,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      tokensRequired: json['tokens_required'] ?? 0,
      validUntil: DateTime.tryParse(json['valid_until'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tokens_required': tokensRequired,
      'valid_until': validUntil.toIso8601String(),
      'status': status,
    };
  }

  String get statusText {
    switch (status) {
      case STATUS_AVAILABLE:
        return 'Disponible';
      case STATUS_LOCKED:
        return 'Bloqueado';
      default:
        return 'Desconocido';
    }
  }
} 