import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/states/borrow_book.dart';
import 'package:sulib/states/search_page.dart';
import 'package:sulib/states/show_progress.dart';
import 'package:sulib/states/show_title.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/widgets/show_logo.dart';
import 'package:sulib/widgets/show_text.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController controllerSearch = TextEditingController();
  PageController controllerPage = PageController(initialPage: 0);

  int currentPageIndex = 0;

  var forYouBookModels = <BookModel>[]; // for สำหรับคุณ // all books in here.
  var faveritBookModels = <BookModel>[]; // for ยอดนิยม
  var newBookModels = <BookModel>[]; // for มาใหม่

  var searchBookModels = <BookModel>[];

  var docForYouBooks = <String>[];
  var docFaveritBooks = <String>[];
  var docNewBooks = <String>[];

  @override
  void dispose() {
    controllerPage.dispose();
    controllerSearch.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    readAllBook();
  }

  Future<void> readAllBook() async {
    await FirebaseFirestore.instance
        .collection('book')
        .get()
        .then((value) async {
      for (var item in value.docs) {
        String docBook = item.id;
        docForYouBooks.add(docBook);

        BookModel bookModel = BookModel.fromMap(item.data());
        forYouBookModels.add(bookModel);
        
        searchBookModels.add(bookModel);

        await FirebaseFirestore.instance
            .collection('book')
            .doc(item.id)
            .collection('borrow')
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            faveritBookModels.add(bookModel);
            docFaveritBooks.add(docBook);
          } else {
            newBookModels.add(bookModel);
            docNewBooks.add(docBook);
          }
        });
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [

          searchButton(),

          const ShowTitle(title: 'สำหรับคุณ'),
          newForYouListView(),
          const ShowTitle(title: 'ยอดนิยม'),
          newFaveritListView(),
          const ShowTitle(title: 'มาใหม่'),
          newListView(),
        ],
      )
    );
  }

  Widget searchButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createRoute(SearchPage(books: forYouBookModels, booksId: docForYouBooks,)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8 , horizontal: 32),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 1, color: MyContant.dark)
            ),
            child: const ShowText(text: 'ค้นหาชื่อหนังสือ'),
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

  SizedBox newForYouListView() {
    return SizedBox(
      height: 200,
      child: forYouBookModels.isEmpty
          ? const ShowProgress()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: forYouBookModels.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BorrowBook(
                        bookModel: forYouBookModels[index],
                        docBook: docForYouBooks[index],
                      ),
                    )),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 150,
                          child: CachedNetworkImage(
                              errorWidget: (context, url, error) =>
                                  const Showlogo(),
                              imageUrl: forYouBookModels[index].cover),
                        ),
                        ShowText(text: cutWord(forYouBookModels[index].title)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  SizedBox newFaveritListView() {
    return SizedBox(
      height: 200,
      child: faveritBookModels.isEmpty
          ? const ShowProgress()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: faveritBookModels.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BorrowBook(
                        bookModel: faveritBookModels[index],
                        docBook: docFaveritBooks[index],
                      ),
                    )),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 150,
                          child: CachedNetworkImage(
                              errorWidget: (context, url, error) =>
                                  const Showlogo(),
                              imageUrl: faveritBookModels[index].cover),
                        ),
                        ShowText(text: cutWord(faveritBookModels[index].title)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  SizedBox newListView() {
    return SizedBox(
      height: 200,
      child: newBookModels.isEmpty
          ? const ShowProgress()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: newBookModels.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BorrowBook(
                        bookModel: newBookModels[index],
                        docBook: docNewBooks[index],
                      ),
                    )),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 150,
                          child: CachedNetworkImage(
                              errorWidget: (context, url, error) =>
                                  const Showlogo(),
                              imageUrl: newBookModels[index].cover),
                        ),
                        ShowText(text: cutWord(newBookModels[index].title)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Row newSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // ShowForm(
        //   width: 300,
        //   label: 'ค้นหาหนังสือ...',      
        //   changeFunc: (String string) {},
        // ),
        
        // IconButton(onPressed: () {}, icon: const Icon(Icons.search),)
        // ShowButton(
        //   label: 'Search',
        //   pressFunc: () {},
        // ),
      ],
    );
  }

  String cutWord(String title) {
    String string = title;
    if (string.length > 20) {
      string = string.substring(0, 20);
      string = '$string ...';
    }
    return string;
  }
}
