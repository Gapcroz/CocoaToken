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
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      tokens: json['tokens'] as int? ?? 0,
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
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

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.tokens,
    required this.rewardsHistory,
    required this.coupons,
  });

  // Obtiene las iniciales del nombre y apellido
  String get initials {
    final nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  // Obtiene el primer nombre
  String get firstName {
    final nameParts = name.trim().split(' ');
    return nameParts.isNotEmpty ? nameParts[0] : '';
  }

  // Obtiene el apellido
  String get lastName {
    final nameParts = name.trim().split(' ');
    return nameParts.length > 1 ? nameParts[1] : '';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      tokens: (json['tokens'] as num?)?.toInt() ?? 0,
      rewardsHistory: (json['rewards_history'] as List?)?.map((i) => 
        RewardHistory.fromJson(i as Map<String, dynamic>)).toList() ?? [],
      coupons: (json['coupons'] as List?)?.map((i) => 
        Coupon.fromJson(i as Map<String, dynamic>)).toList() ?? [],
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
      'rewards_history': rewardsHistory.map((i) => i.toJson()).toList(),
      'coupons': coupons.map((i) => i.toJson()).toList(),
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
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      tokensRequired: (json['tokens_required'] as num?)?.toInt() ?? 0,
      validUntil: DateTime.tryParse(json['valid_until']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? '',
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