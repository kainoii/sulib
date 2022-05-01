import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sulib/mdels/review-model.dart';
import 'package:sulib/states/review.dart';

class BorrowUserModel {
  final String docBook;
  final ReviewModel? review;
  final String borrowId;
  final Timestamp startDate;
  final Timestamp endDate;
  final bool status;

  BorrowUserModel({
    required this.docBook,
    required this.borrowId,
    this.review,
    required this.startDate,
    required this.endDate,
    required this.status
  });

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'docBook': docBook,
      'review': review?.toMap(),
      'borrowId': borrowId
    };
  }

  factory BorrowUserModel.fromMap(Map<String, dynamic> map) {
    return BorrowUserModel(
      docBook: map['docBook'] ?? [],
      borrowId: map['borrowId'] ?? '',
      startDate:(map['startDate']),
      endDate: (map['endDate']),
      status: map['status'] ?? false,
      review: (map['review'] != null) ? ReviewModel.fromMap(map['review']) : null
    );
  }

  String toJson() => json.encode(toMap());

  factory BorrowUserModel.fromJson(String source) => BorrowUserModel.fromMap(json.decode(source));
}

