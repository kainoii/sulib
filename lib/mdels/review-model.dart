import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final double? rate;
  final String? description;
  final Timestamp? date;

  ReviewModel({required this.rate, required this.description, required this.date});

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      rate: (map['rate'] != null)? map['rate'] : null,
      description: (map['description'] != null)? map['description'] : null,
      date: (map['date'] != null) ? map['date'] : null
    );
  }

  Map<String, dynamic> toMapReview() {
    return {
      "rate": rate,
      "description": description,
      "date": date
    };
  }

  String toJson() => json.encode(toMapReview());

}