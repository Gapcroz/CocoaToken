class StoreModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String image;
  final bool isStore;
  final String role;

  StoreModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.image,
    required this.isStore,
    required this.role,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      image: json['image'],
      isStore: json['isStore'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'image': image,
      'isStore': isStore,
      'role': role,
    };
  }
} 