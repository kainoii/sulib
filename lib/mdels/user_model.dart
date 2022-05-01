import 'dart:convert';

import 'package:sulib/mdels/address.dart';

class UserModel {
  final String name;
  final String email;
  final String password;
  List<Address>? address;
  UserModel({
    required this.name,
    required this.email,
    required this.password,
    this.address
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'address' : address
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      address: (map ['address'] != null) ? List<Address>.from(map["address"].map((x) => Address.fromMap(x))) : []
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
