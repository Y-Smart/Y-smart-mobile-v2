import 'dart:convert';

class Device {
  final String id;
  final String owner;
  final String type;
  final String location;
  final String state;
  final String createdAt;

  Device({
    required this.id,
    required this.owner,
    required this.type,
    required this.location,
    required this.state,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'owner': owner,
      'type': type,
      'location': location,
      'state': state,
      'createdAt': createdAt,
    };
  }

  Device copyWith({
    String? id,
    String? owner,
    String? type,
    String? location,
    String? state,
    String? createdAt,
  }) {
    return Device(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      type: type ?? this.type,
      location: location ?? this.location,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['_id'] ?? '',
      owner: map['owner'] ?? '',
      type: map['type'] ?? '',
      location: map['location'] ?? '',
      state: map['state'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Device.fromJson(Map<String, dynamic> json) => Device.fromMap(json);
}