class Order {
  final int? id;
  final String name;
  final String serviceType;
  final double weight;
  final String date;

  Order({
    this.id,
    required this.name,
    required this.serviceType,
    required this.weight,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'serviceType': serviceType,
      'weight': weight,
      'date': date,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      name: map['name'],
      serviceType: map['serviceType'],
      weight: map['weight'],
      date: map['date'],
    );
  }
}
