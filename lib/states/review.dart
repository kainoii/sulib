import 'package:flutter/material.dart';
import 'package:sulib/mdels/my_review_model.dart';
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

  List<MyReview> myReviews = [
    MyReview(title: 'หนังสือเล่มที่ 1', bookId: '123456', date: DateTime.now()),
    MyReview(title: 'หนังสือเล่มที่ 2', bookId: '123456', date: DateTime.now()),
    MyReview(title: 'หนังสือเล่มที่ 3', bookId: '123456', date: DateTime.now()),
    MyReview(title: 'หนังสือเล่มที่ 4', bookId: '123456', date: DateTime.now()),
  ];

  @override
  void initState() {
    super.initState();
    myReviews = List.from(myReviews.reversed);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
      child: Column(
        children: [
          
          const Padding(
            padding:  EdgeInsets.symmetric(vertical: 10),
            child: ShowTitle(title: 'รีวิวการอ่านหนังสือ'),
          ),

          Expanded(
            child: ( myReviews.isNotEmpty ) 
            ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: myReviews.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                MyReview review = myReviews[index];
                return Padding(
                  padding: EdgeInsets.only(top: (index == 0) ? 0 : 8 , bottom: (index == myReviews.length - 1) ? 0 : 8),
                  child: buildReviewBooksItem(review)
                );
              },
            )
            : const Center(
              child: ShowText(text: 'ไม่มีหนังสือให้รีวิว'),
            )
          )

        ],
      ),
    );
  }

  Widget buildReviewBooksItem (MyReview review) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: (){
          Navigator.of(context).push(_createRoute(const ReviewDetail()));
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
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.grey,
                    ),
                    child: const Icon(
                      Icons.book,
                      size: 40,
                      color: Colors.white,
                    ),
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
                            review.title,
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
                        child: ShowText(text: 'คุณได้ยืมเมื่อวันที่ ${review.date.day}-${review.date.month}-${ review.date.year }')
                      ),
                      const SizedBox(height: 16,),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: MyContant.dark,
                            elevation: 0,
                            shape: StadiumBorder()
                          ),
                          onPressed: () {
                            Navigator.of(context).push(_createRoute(const ReviewDetail()));
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
