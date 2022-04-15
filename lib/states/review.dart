import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/mdels/borrow_book_model.dart';
import 'package:sulib/mdels/borrow_user_model.dart';
import 'package:sulib/states/review_detail.dart';
import 'package:sulib/states/show_title.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/widgets/show_text.dart';

class Review extends StatefulWidget {
  const Review({ Key? key }) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {


  String? docUser;

  bool isLoading = false;

  List<String> docUserBorrowBookId = [];

  List<BorrowUserModel> bookReviewsByUser = [];
  List<BookModel> books = [];
  List<String> docBookIds = [];

  Stream<List<BorrowUserModel>> getUserBooksReviews() async* {
    docUserBorrowBookId.clear();
    bookReviewsByUser.clear();
    final value = await FirebaseFirestore.instance
                      .collection('user')
                      .doc(docUser)
                      .collection('borrow')
                      .where('status', isEqualTo: false)
                      .where('review', isNull: true)
                      .get();
    if (value.docs.isNotEmpty) {
      for (var item in value.docs) {
        docUserBorrowBookId.add(item.id);
        print("Book Id -> ${ item.id }");
        final borrowUserModel = BorrowUserModel.fromMap(item.data());
        print("BookReviewUser -> ${ borrowUserModel.docBook }");
        bookReviewsByUser.add(borrowUserModel);
      }
    }
    
    yield bookReviewsByUser;
  }

  Future<List<BookModel>> getBooks(List<String> documentBooks) async {
    books.clear();
    for (var docBooks in documentBooks) {
      await FirebaseFirestore.instance
                .collection('book')
                .doc(docBooks)
                .get()
                .then((value) {
              final bookModel = BookModel.fromMap(value.data()!);
              books.add(bookModel);
              print("Book title -> ${ bookModel.title }");
            });
    }
    return books;
  }

  Future<void> findUserLogin() async {
      setState(() {
        isLoading = true;
      });
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      setState(() {
        docUser = event!.uid;
        print('find User finish');
      });
    });
    setState(() {
        isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    findUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
      child: (isLoading)
      ? const Center(
        child: CircularProgressIndicator(color: Colors.teal,),
      ) 
      : Column(
        children: [
          
          const Padding(
            padding:  EdgeInsets.symmetric(vertical: 10),
            child: ShowTitle(title: 'รีวิวการอ่านหนังสือ'),
          ),

          Expanded(
            child: StreamBuilder(
              stream: getUserBooksReviews(),
              builder: (BuildContext context,AsyncSnapshot<List<BorrowUserModel>> snapshotBookReviews) {
                if (!snapshotBookReviews.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.teal,),
                  );
                }
                for (var element in bookReviewsByUser) {
                  docBookIds.add(element.docBook);
                }
                return FutureBuilder(
                  future: getBooks(docBookIds),
                  builder: (BuildContext context,AsyncSnapshot<List<BookModel>> snapshotBooks) {
                    if (!snapshotBooks.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.green,),
                      );
                    }
                    return (bookReviewsByUser.isNotEmpty)
                    ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: bookReviewsByUser.length,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: (index == 0) ? 0 : 8 , bottom: (index == bookReviewsByUser.length - 1) ? 0 : 8),
                          child: buildReviewBooksItem(bookReviewsByUser[index], books[index], docUserBorrowBookId[index])
                        );
                      },
                    )
                    : const Center(
                      child: ShowText(
                        text: "ไม่มีหนังสือสำหรับการรีวิว",
                      ),
                    );
                  },
                );
              },
            )
            
          )

        ],
      ),
    );
  }

  Widget buildReviewBooksItem (BorrowUserModel review, BookModel book, String docUserBorrowBook) {
    DateTime date = review.startDate.toDate();
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          final response = await Navigator.of(context).push(
            _createRoute(
              ReviewDetail(
                docBorrowId: docUserBorrowBook, 
                docUser: docUser!, 
                borrowUserModel: review, 
                bookModel: book,
              )
            )
          );

          if (response != null) {
            Map<String, dynamic> data = response;
            if (data['isReview']) {
              setState(() {
                int indexRemove = bookReviewsByUser.indexOf(review);
                bookReviewsByUser.removeAt(indexRemove);
                docBookIds.removeAt(indexRemove);
                books.removeAt(indexRemove);
                docUserBorrowBookId.removeAt(indexRemove);
              });
            }
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: CachedNetworkImage(
                    imageUrl: book.cover,
                    fit: BoxFit.fitHeight,
                    width: 100,
                  ),
                ),
                const SizedBox(width: 16,),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 4,),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            book.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: MyContant.black
                            ),
                          )
                      ),
                      const SizedBox(height: 6,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ShowText(text: 'คุณได้ยืมเมื่อวันที่ ${date.day}-${date.month}-${ date.year }')
                      ),
                      const SizedBox(height: 16,),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: MyContant.dark,
                            elevation: 0,
                            shape: const StadiumBorder()
                          ),
                          onPressed: () async {
                            final response = await Navigator.of(context).push(
                              _createRoute(
                                ReviewDetail(
                                  docBorrowId: docUserBorrowBook, 
                                  docUser: docUser!, 
                                  borrowUserModel: 
                                  review, bookModel: 
                                  book,
                                )
                              )
                            );

                            if (response != null) {
                              Map<String, dynamic> data = response;
                              if (data['isReview']) {
                                setState(() {
                                  int indexRemove = bookReviewsByUser.indexOf(review);
                                  bookReviewsByUser.removeAt(indexRemove);
                                  docBookIds.removeAt(indexRemove);
                                  books.removeAt(indexRemove);
                                  docUserBorrowBookId.removeAt(indexRemove);
                                });
                              }
                            }
                          } ,
                          icon: const Icon(Icons.star, color: Colors.white, size: 17,),
                          label: const Text(
                            'ให้คะแนน',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }


}
