class ObjectModel {
  int? id;
  String name;
  String description;
  DateTime timestamp;

  ObjectModel({
    this.id,
    required this.name,
    required this.description,
    required this.timestamp,
  });

  factory ObjectModel.fromMap(Map<String, dynamic> map) {
    return ObjectModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      timestamp: DateTime.parse(map['timestamp'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  ObjectModel copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? timestamp,
  }) {
    return ObjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      timestamp: timestamp ??
          this.timestamp,
    );
  }
}
