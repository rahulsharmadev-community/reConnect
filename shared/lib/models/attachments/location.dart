import 'dart:convert';

import 'package:equatable/equatable.dart';

class Location extends Equatable {
  Location({
    DateTime? createdAt,
    required this.longitude,
    required this.latitude,
    this.name,
    this.address,
  }) : createdAt = createdAt ?? DateTime.now();

  final String longitude;
  final String latitude;
  final DateTime createdAt;
  final String? name;
  final String? address;

  Location copyWith({
    String? name,
    DateTime? createdAt,
    String? longitude,
    String? latitude,
    String? address,
  }) =>
      Location(
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        address: address ?? this.address,
      );

  factory Location.fromJson(String str) => Location.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Location.fromMap(Map<String, dynamic> map) => Location(
        createdAt: DateTime.fromMillisecondsSinceEpoch(map["created_at"]),
        longitude: map["longitude"],
        latitude: map["latitude"],
        name: map["name"],
        address: map["address"],
      );

  Map<String, dynamic> toMap() => {
        "created_at": createdAt.millisecondsSinceEpoch,
        "longitude": longitude,
        "latitude": latitude,
        if (name != null) "name": name,
        if (address != null) "address": address,
      };

  @override
  List<Object?> get props => [longitude, latitude, createdAt, name, address];
}
