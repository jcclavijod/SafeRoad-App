class Service {
  final String customerAcceptance;
  final String date;

  final List<String> worksPerformed;
  final double totalCost;

  const Service({
    required this.worksPerformed,
    required this.totalCost,
    required this.customerAcceptance,
    required this.date,});

  factory Service.fromMap(Map<String, dynamic> map) {
    final List<String> workPerformed =
        List<String>.from(map['worksPerformed'] ?? []);
    return Service(
      customerAcceptance: map["customerAcceptance"].toString(),
      date: map['date']?.toString() ?? '',
      worksPerformed: workPerformed,
      totalCost: (map['totalCost'] ?? 0.0).toDouble(),
    );
  }

  // Enviando los datos al servidor DB
  Map<String, dynamic> toMap() {
    return {
      'workPerformed': worksPerformed,
      'totalCost': totalCost,
      'customerAcceptance': customerAcceptance,
      'date': date,
    };
  }
}
