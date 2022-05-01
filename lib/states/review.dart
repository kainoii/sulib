import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sulib/controller/auth_controller.dart';
import 'package:sulib/mdels/book-model.dart';
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

  bool isLoading = false;

  List<String> docUserBorrowBookId = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void onRefresh() {
    setState(() {
      docUserBorrowBookId.clear();
    });
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserBooksReviews() async {
    String userId = AuthController.instance.getUserId();
    final value = await FirebaseFirestore.instance
                      .collection(Collection.user)
                      .doc(userId)
                      .collection(Collection.borrow)
                      .where("status", isEqualTo: false)
                      .where('review', isNull: true)
                      .get();

    return value.docs;
  }

  List<BorrowUserModel> getReviews(List<QueryDocumentSnapshot<Map<String, dynamic>>> reviews) {
    List<BorrowUserModel> reviewList = [];
    if (reviews.isNotEmpty) {
      for (var review in reviews) {
        docUserBorrowBookId.add(review.id);
        print("Book Id -> ${ review.id }");
        final borrowUserModel = BorrowUserModel.fromMap(review.data());
        print("BookReviewUser -> ${ borrowUserModel.docBook }");
        reviewList.add(borrowUserModel);
      }
    } else {
      print('review is Empty');
    }
    reviewList.sort((a, b) => a.startDate.compareTo(b.startDate));
    reviewList = List.of(reviewList).reversed.toList();
    return reviewList;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getBooksFromFirebase(String docBook) async {

    return await FirebaseFirestore.instance
        .collection(Collection.book)
        .doc(docBook)
        .get();
  }

  Future<List<BookModel>> getBooks(List<String> documentBooks) async {
    List<BookModel> bookList = [];
    for(var docBook in documentBooks) {
      final response = await getBooksFromFirebase(docBook);
      BookModel bookModel = BookModel.fromMap(response.data()!);
      bookList.add(bookModel);
    }
    return bookList;
  }
  //
  // Future<void> findUserLogin() async {
  //     setState(() {
  //       isLoading = true;
  //     });
  //   await FirebaseAuth.instance.authStateChanges().listen((event) {
  //     setState(() {
  //       docUser = event!.uid;
  //
  //     });
  //   });
  //   setState(() {
  //       isLoading = false;
  //   });
  // }


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
            child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              future: getUserBooksReviews(),
              builder: (context, snapshotReview) {
                if (snapshotReview.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.teal,),
                  );
                } else {
                  if (snapshotReview.hasError) {
                    return Center(
                      child: Text('Error: ${ snapshotReview.error }'),
                    );
                  }
                  List<BorrowUserModel> borrowUserModel = getReviews(snapshotReview.data!);
                  if (borrowUserModel.isEmpty) {
                    return Center(
                      child: Text(
                        'ไม่มีหนังสือให้รีวิว',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: MyContant.dark
                        ),
                      ),
                    );
                  }
                  return buildBookDataWidget(borrowUserModel);
                }
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget buildBookDataWidget(List<BorrowUserModel> borrowUserModel) {

    List<String> docBookIds = [];

    for (var element in borrowUserModel) {
      docBookIds.add(element.docBook);
    }
    return FutureBuilder<List<BookModel>>(
      future: getBooks(docBookIds),
      builder: (context, snapshotBooks) {
        if (snapshotBooks.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green,),
          );
        } else {
          if (snapshotBooks.hasError) {
            return Center(
              child: ShowText(text: 'Error: ${snapshotBooks.error}'),
            );
          }
          List<BookModel> bookModel = snapshotBooks.data!;
          bookModel.forEach((element) {
            print("Future Finish book data: ${element.title}");
          });
          return buildListBookReview(borrowUserModel, bookModel);
        }
      },
    );
  }

  Widget buildListBookReview(List<BorrowUserModel> borrowUserModel, List<BookModel> bookModel) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: bookModel.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return Padding(
            padding: EdgeInsets.only(top: (index == 0) ? 0 : 8 , bottom: (index == borrowUserModel.length - 1) ? 0 : 8),
            child: buildReviewBooksItem(borrowUserModel[index], bookModel[index], docUserBorrowBookId[index])
        );
      },
    );
  }

  Widget buildReviewBooksItem (BorrowUserModel borrowUserModel, BookModel bookModel, String docUserBorrowBook) {
    DateTime date = borrowUserModel.startDate.toDate();
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          final response = await Navigator.of(context).push(
            _createRoute(
              ReviewDetail(
                docUser: AuthController.instance.getUserId(),
                borrowUserModel: borrowUserModel,
                bookModel: bookModel,
              )
            )
          );

          if (response != null) {
            Map<String, dynamic> data = response;
            if (data['isReview']) {
              onRefresh();
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
                    imageUrl: bookModel.cover,
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
                            bookModel.title,
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
                                  docUser: AuthController.instance.getUserId(),
                                  borrowUserModel: borrowUserModel,
                                  bookModel: bookModel,
                                )
                              )
                            );

                            if (response != null) {
                              Map<String, dynamic> data = response;
                              if (data['isReview']) {
                                onRefresh();
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
