class CauseOfFailure {
  final String id;
  final String name;

  const CauseOfFailure({required this.id, required this.name});

  factory CauseOfFailure.fromMap(Map<String, dynamic> map) {
    return CauseOfFailure(
      id: map["id"].toString(),
      name: map['name']?.toString() ?? '',
    );
  }

  // Enviando los datos al servidor DB
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }
}
