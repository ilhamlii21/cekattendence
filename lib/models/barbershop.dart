class Barbershop {
  final String id;
  final String name;
  final String address;

  Barbershop({
    required this.id,
    required this.name,
    required this.address,
  });

  factory Barbershop.fromJson(Map<String, dynamic> json) {
    return Barbershop(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
    );
  }
}
