import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReserveModel {
  final String cover;
  final String docBook;
  final Timestamp endDate;
  final String nameBook;
  final bool status;
  ReserveModel({
    required this.cover,
    required this.docBook,
    required this.endDate,
    required this.nameBook,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'cover': cover,
      'docBook': docBook,
      'endDate': endDate,
      'nameBook': nameBook,
      'status': status,
    };
  }

  factory ReserveModel.fromMap(Map<String, dynamic> map) {
    return ReserveModel(
      cover: map['cover'] ?? '',
      docBook: map['docBook'] ?? '',
      endDate: (map['endDate']),
      nameBook: map['nameBook'] ?? '',
      status: map['status'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReserveModel.fromJson(String source) => ReserveModel.fromMap(json.decode(source));
}
