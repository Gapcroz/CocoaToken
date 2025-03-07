class CouponModel {
  final String id;
  final String name;
  final String description;
  final int tokensRequired;
  final DateTime validUntil;
  final String status;

  CouponModel({
    required this.id,
    required this.name,
    required this.description,
    required this.tokensRequired,
    required this.validUntil,
    required this.status,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      tokensRequired: json['tokens_required'] as int,
      validUntil: DateTime.parse(json['valid_until'] as String),
      status: json['status'] as String,
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

  bool get isAvailable => status == 'available';
} 