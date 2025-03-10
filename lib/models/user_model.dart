import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final int tokens;
  final String profileImage;
  final String membershipLevel;
  final List<Transaction> transactions;
  final List<Reward> rewards;
  final List<Store> favoriteStores;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.tokens,
    required this.profileImage,
    required this.membershipLevel,
    required this.transactions,
    required this.rewards,
    required this.favoriteStores,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      tokens: json['tokens'],
      profileImage: json['profile_image'],
      membershipLevel: json['membership_level'],
      transactions: (json['transactions'] as List)
          .map((i) => Transaction.fromJson(i))
          .toList(),
      rewards: (json['rewards'] as List)
          .map((i) => Reward.fromJson(i))
          .toList(),
      favoriteStores: (json['favorite_stores'] as List)
          .map((i) => Store.fromJson(i))
          .toList(),
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
      'profile_image': profileImage,
      'membership_level': membershipLevel,
      'transactions': transactions.map((i) => i.toJson()).toList(),
      'rewards': rewards.map((i) => i.toJson()).toList(),
      'favorite_stores': favoriteStores.map((i) => i.toJson()).toList(),
    };
  }
}

class Transaction {
  final String id;
  final DateTime date;
  final String type;
  final int amount;
  final String description;

  Transaction({
    required this.id,
    required this.date,
    required this.type,
    required this.amount,
    required this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      date: DateTime.parse(json['date']),
      type: json['type'],
      amount: json['amount'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'amount': amount,
      'description': description,
    };
  }
}

class Reward {
  final String id;
  final String name;
  final String description;
  final int tokensRequired;
  final DateTime validUntil;
  final String status;

  Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.tokensRequired,
    required this.validUntil,
    required this.status,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      tokensRequired: json['tokens_required'],
      validUntil: DateTime.parse(json['valid_until']),
      status: json['status'],
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
}

class Store {
  final String id;
  final String name;
  final String logo;
  final String address;
  final int tokensEarned;

  Store({
    required this.id,
    required this.name,
    required this.logo,
    required this.address,
    required this.tokensEarned,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      address: json['address'],
      tokensEarned: json['tokens_earned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'address': address,
      'tokens_earned': tokensEarned,
    };
  }
} 