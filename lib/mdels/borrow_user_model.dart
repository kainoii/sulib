import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sulib/mdels/review-model.dart';

class BorrowUserModel {
  final String docBook;
  final Timestamp startDate;
  final Timestamp endDate;
  final bool status;
  final ReviewModel? review;
  BorrowUserModel({
    required this.docBook,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.review
  });

  Map<String, dynamic> toMap() {
    return {
      'docBook': docBook,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'review': review?.toMapReview()
    };
  }

  factory BorrowUserModel.fromMap(Map<String, dynamic> map) {
    return BorrowUserModel(
      docBook: map['docBook'] ?? '',
      startDate:(map['startDate']),
      endDate: (map['endDate']),
      status: map['status'] ?? false,
      review: (map['review'] != null) ? ReviewModel.fromMap(map['review']) : null
    );
  }

  String toJson() => json.encode(toMap());

  factory BorrowUserModel.fromJson(String source) => BorrowUserModel.fromMap(json.decode(source));
}

