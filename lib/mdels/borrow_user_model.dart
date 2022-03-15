import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowUserModel {
  final String docBook;
  final Timestamp startDate;
  final Timestamp endDate;
  final bool status;
  BorrowUserModel({
    required this.docBook,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'docBook': docBook,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
    };
  }

  factory BorrowUserModel.fromMap(Map<String, dynamic> map) {
    return BorrowUserModel(
      docBook: map['docBook'] ?? '',
      startDate:(map['startDate']),
      endDate: (map['endDate']),
      status: map['status'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory BorrowUserModel.fromJson(String source) => BorrowUserModel.fromMap(json.decode(source));
}
