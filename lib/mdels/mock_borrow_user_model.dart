import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sulib/states/review.dart';

class MockBorrowUserModel {
  final List<String>? docBooks;
  final Timestamp startDate;
  final Timestamp endDate;
  final bool status;
  final List<DetailReview>? review;

  MockBorrowUserModel({
    this.docBooks,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.review
  });

}

class DetailReview {
  final String docBook;
  final Review? review;

  DetailReview({required this.docBook, this.review});

}