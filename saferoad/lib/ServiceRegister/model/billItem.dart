class BillItem {
  String name;
  double value;

  BillItem({required this.name, required this.value});

  factory BillItem.fromMap(Map<String, dynamic> map) {
    return BillItem(
      name: map["name"].toString(),
      value: (map['cost'] ?? 0.0).toDouble(),
    );
  }

  // Enviando los datos al servidor DB
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "value": value,
    };
  }
}
