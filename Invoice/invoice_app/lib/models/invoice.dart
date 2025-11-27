class InvoiceItemLine {
  final String description;
  final int qty;
  final double unitPrice;
  final double total;

  InvoiceItemLine({
    required this.description,
    required this.qty,
    required this.unitPrice,
    required this.total,
  });

  factory InvoiceItemLine.fromJson(Map<String, dynamic> json) {
    return InvoiceItemLine(
      description: json["description"] ?? "",
      qty: json["qty"] ?? 0,
      unitPrice: double.tryParse(json["unitPrice"].toString()) ?? 0,
      total: double.tryParse(json["total"].toString()) ?? 0,
    );
  }
}

class InvoiceModel {
  final String id;
  final String number;
  final String status;
  final String clientId;
  final double subTotal;
  final double tax;
  final double discount;
  final double total;
  final List<InvoiceItemLine> items;

  InvoiceModel({
    required this.id,
    required this.number,
    required this.status,
    required this.clientId,
    required this.subTotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.items,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json["_id"],
      number: json["number"] ?? "",
      status: json["status"],
      clientId: json["clientId"],
      subTotal: double.tryParse(json["subTotal"].toString()) ?? 0,
      tax: double.tryParse(json["tax"].toString()) ?? 0,
      discount: double.tryParse(json["discount"].toString()) ?? 0,
      total: double.tryParse(json["total"].toString()) ?? 0,
      items: (json["items"] as List)
          .map((i) => InvoiceItemLine.fromJson(i))
          .toList(),
    );
  }
}
