import './user_model.dart';
import 'package:flutter/foundation.dart';

class CouponModel {
  final String id;
  final String name;
  final String description;
  final int tokensRequired;
  final DateTime expirationDate;
  final CouponStatus status;

  CouponModel({
    required this.id,
    required this.name,
    required this.description,
    required this.tokensRequired,
    required this.expirationDate,
    required this.status,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    try {
      return CouponModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        tokensRequired: json['tokens_required'] as int? ?? 0,
        expirationDate:
            DateTime.tryParse(json['valid_until']?.toString() ?? '') ??
            DateTime.now(),
        status: _parseStatus(json['status']?.toString()),
      );
    } catch (e) {
      debugPrint('Error parsing CouponModel: $e');
      // Retornar un cupón por defecto en caso de error
      return CouponModel(
        id: '',
        name: '',
        description: '',
        tokensRequired: 0,
        expirationDate: DateTime.now(),
        status: CouponStatus.locked,
      );
    }
  }

  static CouponStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'available':
        return CouponStatus.available;
      case 'used':
        return CouponStatus.used;
      case 'expired':
        return CouponStatus.expired;
      default:
        return CouponStatus.locked;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tokens_required': tokensRequired,
      'valid_until': expirationDate.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  String getStatusString() {
    switch (status) {
      case CouponStatus.available:
        return 'Activo';
      case CouponStatus.locked:
        return 'Inactivo';
      case CouponStatus.expired:
        return 'Expirado';
      case CouponStatus.used:
        return 'Usado';
    }
  }

  bool get isAvailable => status == CouponStatus.available;
  bool get isLocked => status == CouponStatus.locked;
  bool get isUsed => status == CouponStatus.used;
  bool get isExpired => status == CouponStatus.expired;

  DateTime get validUntil => expirationDate;
}
