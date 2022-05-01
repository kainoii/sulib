import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sulib/mdels/address.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/mdels/borrow_book_model.dart';
import 'package:sulib/mdels/borrow_user_model.dart';
import 'package:sulib/mdels/refund_model.dart';
import 'package:sulib/mdels/reserve_model.dart';
import 'package:sulib/mdels/user_model.dart';
import 'package:sulib/utility/my_constant.dart';

class DatabaseService {

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<UserModel> getUser(String id) async* {
    var snap = await db.collection(Collection.user).doc(id).get();
    yield UserModel.fromMap(snap.data()!);
  }

  Future<UserModel> getUserById(String id) async {
    var snap = await db.collection(Collection.user).doc(id).get();
    return UserModel.fromMap(snap.data()!);
  }

  Future<BookModel> getBookById(String bookId) async {
    final response = await db.collection(Collection.book).doc(bookId).get();
    return BookModel.fromMap(response.data()!);
  }

  Future<List<BorrowUserModel>> getBorrowByUser(String userId) async{
    List<BorrowUserModel> borrowUserModel = [];
    final response = await db.collection(Collection.user).doc(userId)
            .collection(Collection.borrow)
            .orderBy("startDate", descending: true)
            .get();
    if (response.docs.isNotEmpty) {
      for(var item in response.docs) {
        borrowUserModel.add(BorrowUserModel.fromMap(item.data()));
      }
    }
    return borrowUserModel;
  }

  Future<String> getDocumentBookBorrowById(String bookId) async {
    final response = await db.collection(Collection.book).doc(bookId)
        .collection(Collection.borrow)
        .where("status", isEqualTo: true)
        .get();
    return response.docs.first.id;
  }

  Future<List<String>> getDocumentUserBorrowByUserId(String userId) async {
    final response = await db.collection(Collection.user).doc(userId)
        .collection(Collection.borrow)
        .where('status', isEqualTo: true)
        .get();

    return response.docs.map((item) => item.id).toList();
  }

  Future updateBookBorrow(String bookId, String docBookBorrow, Map<String, dynamic> data) async {
    await db.collection(Collection.book).doc(bookId)
        .collection(Collection.borrow)
        .doc(docBookBorrow)
        .update(data);
  }

  Future updateUserBorrow(String userId, String docUserBorrow, Map<String, dynamic> data) async {
    await db.collection(Collection.user).doc(userId)
        .collection(Collection.borrow)
        .doc(docUserBorrow)
        .update(data);
  }

  Future<List<BorrowBookModel>> getBookIsBorrowedByBookId(String bookId) async{
    List<BorrowBookModel> borrowBookModels = [];
    final response = await db.collection(Collection.book).doc(bookId)
        .collection(Collection.borrow)
        .where("status", isEqualTo: true)
        .get();
    if (response.docs.isNotEmpty) {
      for(var item in response.docs) {
        borrowBookModels.add(BorrowBookModel.fromMap(item.data()));
      }
    }
    return borrowBookModels;
  }

  Future<void> reserveBook(String userId, Map<String, dynamic> mapData) async {
    await FirebaseFirestore.instance
        .collection(Collection.user)
        .doc(userId)
        .collection(Collection.reserve)
        .doc()
        .set(mapData);
  }

  Future<void> insertAddress(String userId, Address address) async {
    Map<String, dynamic> data = {
      "address" : FieldValue.arrayUnion([address.toMap()])
    };

    await  FirebaseFirestore.instance
        .collection(Collection.user)
        .doc(userId)
        .update(data);
  }

  Future<void> deleteAddress(String userId, Address address) async {
    Map<String, dynamic> data = {
      "address" : FieldValue.arrayRemove([address.toMap()])
    };
    await  FirebaseFirestore.instance
        .collection(Collection.user)
        .doc(userId)
        .update(data);
  }

  Future<void> updateAddress(String userId, Address oldAddress, Address newAddress) async{
    await deleteAddress(userId, oldAddress).then((value) {
      insertAddress(userId, newAddress);
    });
  }

  Future<List<String>> getDocumentBookByList(List<BookModel> books) async {
    List<String> documentBookList = [];
    for (var item in books) {
      final response = await FirebaseFirestore.instance
          .collection(Collection.book)
          .where("ISBN number", isEqualTo: item.isbnNumber)
          .get();
      if (response.docs.isNotEmpty) {
        documentBookList.add(response.docs.first.id);
      }
    }
    return documentBookList;
  }

  Future<List<BorrowBookModel>> verifyBookBorrowed(List<String> allBookId) async {
    List<BorrowBookModel> borrowBookModels = [];

    for(var docBook in allBookId) {
      final response = await FirebaseFirestore.instance
          .collection(Collection.book)
          .doc(docBook)
          .collection(Collection.borrow)
          .where("status", isEqualTo: true)
          .get();
      if (response.docs.isNotEmpty) {
        BorrowBookModel borrowBookModel = BorrowBookModel.fromMap(response.docs.first.data());
        borrowBookModels.add(borrowBookModel);
      }
    }
    return borrowBookModels;
  }

  Future<List<int>> verifyBookBorrowedByDocumentList(List<String> allBookId) async {
    List<int> borrowBookModels = [];

    for(int i=0; i < allBookId.length; i++) {
      final response = await FirebaseFirestore.instance
          .collection(Collection.book)
          .doc(allBookId[i])
          .collection(Collection.borrow)
          .where("status", isEqualTo: true)
          .get();
      if (response.docs.isNotEmpty) {
        borrowBookModels.add(i);
      }
    }
    return borrowBookModels;
  }

  Future borrowBookByUser(String userId, BorrowUserModel borrowUserModel) async {
    await FirebaseFirestore.instance
        .collection(Collection.user)
        .doc(userId)
        .collection(Collection.borrow)
        .doc()
        .set(borrowUserModel.toMap());
  }

  Future borrowBookByBook(String bookId, BorrowBookModel borrowBookModel) async {
    await FirebaseFirestore.instance
        .collection(Collection.book)
        .doc(bookId)
        .collection(Collection.borrow)
        .doc()
        .set(borrowBookModel.toMap());
  }
  
  Future<List<BorrowUserModel>> getAllBookBorrowByUser(String userId) async {
    List<BorrowUserModel> borrowUserModels = [];
    final response = await FirebaseFirestore.instance.collection(Collection.user)
                        .doc(userId).collection(Collection.borrow)
                        .orderBy("startDate", descending: true).get();
    if(response.docs.isNotEmpty) {
      borrowUserModels = response.docs.map((item) => BorrowUserModel.fromMap(item.data())).toList();
    }
    return borrowUserModels;
  }

}