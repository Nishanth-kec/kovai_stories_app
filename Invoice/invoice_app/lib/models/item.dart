class ItemModel {
  final String id;
  final String name;
  final String? description;
  final double? unitPrice;
  final String? sku;

  ItemModel({
    required this.id,
    required this.name,
    this.description,
    this.unitPrice,
    this.sku,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json["_id"],
      name: json["name"] ?? "",
      description: json["description"],
      unitPrice: json["unitPrice"] != null
          ? double.tryParse(json["unitPrice"].toString())
          : null,
      sku: json["sku"],
    );
  }
}
