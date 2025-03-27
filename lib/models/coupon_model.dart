import 'package:cocoa_token_front/models/user_model.dart'; // Para acceder a CouponStatus

class CouponModel {
  final String id;
  final String name;
  final String description;
  final double discount;
  final String code;
  final DateTime validUntil;
  final CouponStatus status;
  final String? storeId;
  final int? tokensRequired;
  final String? imageUrl;

  CouponModel({
    required this.id,
    required this.name,
    required this.description,
    required this.discount,
    required this.code,
    required this.validUntil,
    required this.status,
    this.storeId,
    this.tokensRequired,
    this.imageUrl,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      discount: (json['discount'] ?? 0.0).toDouble(),
      code: json['code'] ?? '',
      validUntil:
          DateTime.tryParse(json['valid_until'] ?? '') ?? DateTime.now(),
      status: CouponStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => CouponStatus.locked,
      ),
      storeId: json['store_id'],
      tokensRequired: json['tokens_required'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'discount': discount,
      'code': code,
      'valid_until': validUntil.toIso8601String(),
      'status': status.name,
      'store_id': storeId,
      'tokens_required': tokensRequired,
      'image_url': imageUrl,
    };
  }

  String get statusText {
    switch (status) {
      case CouponStatus.available:
        return 'Disponible';
      case CouponStatus.locked:
        return 'Bloqueado';
      case CouponStatus.used:
        return 'Usado';
      case CouponStatus.expired:
        return 'Expirado';
    }
  }

  bool get isAvailable => status == CouponStatus.available;
  bool get isLocked => status == CouponStatus.locked;
  bool get isUsed => status == CouponStatus.used;
  bool get isExpired => status == CouponStatus.expired;
}
