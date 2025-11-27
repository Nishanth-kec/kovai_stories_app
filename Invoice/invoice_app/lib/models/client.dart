class ClientModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? notes;

  ClientModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.notes,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json["_id"],
      name: json["name"] ?? "",
      email: json["email"],
      phone: json["phone"],
      address: json["address"],
      notes: json["notes"],
    );
  }
}
