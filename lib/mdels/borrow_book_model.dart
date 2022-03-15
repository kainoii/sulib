import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowBookModel {
  final String docUser;
  final Timestamp startDate;
  final Timestamp endDate;
  final bool status;
  BorrowBookModel({
    required this.docUser,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'docUser': docUser,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
    };
  }

  factory BorrowBookModel.fromMap(Map<String, dynamic> map) {
    return BorrowBookModel(
      docUser: map['docUser'] ?? '',
      startDate:(map['startDate']),
      endDate:(map['endDate']),
      status: map['status'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory BorrowBookModel.fromJson(String source) => BorrowBookModel.fromMap(json.decode(source));
}
