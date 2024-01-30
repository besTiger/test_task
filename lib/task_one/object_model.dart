class ObjectModel {
  int? id;
  String name;
  String description;

  ObjectModel({
    this.id,
    required this.name,
    required this.description,
  });

  factory ObjectModel.fromMap(Map<String, dynamic> map) {
    return ObjectModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  ObjectModel copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return ObjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
