class CompanyModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? taxNumber;
  final String? logoUrl;

  CompanyModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.taxNumber,
    this.logoUrl,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json["_id"],
      name: json["name"] ?? "",
      email: json["email"],
      phone: json["phone"],
      address: json["address"],
      taxNumber: json["taxNumber"],
      logoUrl: json["logoUrl"],
    );
  }
}
