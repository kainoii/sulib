import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/mdels/borrow_user_model.dart';

class RefundModel{
  final BookModel bookModel;
  final BorrowUserModel borrowUserModel;

  RefundModel({required this.bookModel, required this.borrowUserModel});
}