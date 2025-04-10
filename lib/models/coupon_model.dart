import 'package:flutter/foundation.dart';
import 'coupon_status.dart';

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
      debugPrint('Parseando cupón: ${json['id']}');
      debugPrint('JSON completo recibido: $json');
      debugPrint(
        'Tipo de tokensRequired en JSON: ${json['tokensRequired']?.runtimeType}',
      );

      int parsedTokens;
      var rawTokens = json['tokensRequired'];
      if (rawTokens is int) {
        parsedTokens = rawTokens;
      } else if (rawTokens is String) {
        parsedTokens = int.tryParse(rawTokens) ?? 0;
      } else {
        parsedTokens = 0;
        debugPrint(
          'ADVERTENCIA: tokensRequired no es int ni String: $rawTokens',
        );
      }

      debugPrint('Tokens parseados: $parsedTokens');

      final coupon = CouponModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        tokensRequired: parsedTokens,
        expirationDate:
            DateTime.tryParse(json['expirationDate']?.toString() ?? '') ??
            DateTime.now(),
        status: _parseStatus(json['status']?.toString()),
      );
      debugPrint(
        'Cupón parseado - tokensRequired final: ${coupon.tokensRequired}',
      );
      return coupon;
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
    debugPrint('Serializando cupón ID: $id');
    debugPrint('Tokens antes de serializar: $tokensRequired');

    final json = {
      'id': id,
      'name': name,
      'description': description,
      'tokensRequired': tokensRequired,
      'expirationDate': expirationDate.toIso8601String(),
      'status': status.toString().split('.').last,
    };

    debugPrint('JSON generado: $json');
    debugPrint('Tokens en el JSON: ${json['tokensRequired']}');
    debugPrint(
      'Tipo de tokens en el JSON: ${json['tokensRequired'].runtimeType}',
    );
    return json;
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
