import 'dart:convert';

class BookModel {
  final String name;
  final String cover;
  BookModel({
    required this.name,
    required this.cover,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cover': cover,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      name: map['name'] ?? '',
      cover: map['cover'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BookModel.fromJson(String source) => BookModel.fromMap(json.decode(source));
}
