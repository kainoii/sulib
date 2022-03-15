import 'dart:convert';

class BookModel {
  final String cover;
  final String isbnNumber;
  final String publisher;
  final String author;
  final String bookCatetory;
  final String bookCode;
  final String detail;
  final String numberOfPage;
  final String title;
  final String yearOfImport;
  BookModel({
    required this.cover,
    required this.isbnNumber,
    required this.publisher,
    required this.author,
    required this.bookCatetory,
    required this.bookCode,
    required this.detail,
    required this.numberOfPage,
    required this.title,
    required this.yearOfImport,
  });
 

  Map<String, dynamic> toMap() {
    return {
      'cover': cover,
      'ISBN Number': isbnNumber,
      'Publisher': publisher,
      'author': author,
      'book category': bookCatetory,
      'book code': bookCode,
      'details': detail,
      'number of pages': numberOfPage,
      'title': title,
      'year of import': yearOfImport,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      cover: map['cover'] ?? '',
      isbnNumber: map['ISBN Number'] ?? '',
      publisher: map['Publisher'] ?? '',
      author: map['author'] ?? '',
      bookCatetory: map['book category'] ?? '',
      bookCode: map['book code'] ?? '',
      detail: map['details'] ?? '',
      numberOfPage: map['number of pages'] ?? '',
      title: map['title'] ?? '',
      yearOfImport: map['year of import'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BookModel.fromJson(String source) => BookModel.fromMap(json.decode(source));
}
