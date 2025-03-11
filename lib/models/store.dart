class Store {
  final String name;
  final String logo;

  Store({
    required this.name,
    required this.logo,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
} 