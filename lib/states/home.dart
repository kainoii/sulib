import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/states/borrow_book.dart';
import 'package:sulib/states/show_progress.dart';
import 'package:sulib/states/show_title.dart';
import 'package:sulib/widgets/show_button.dart';
import 'package:sulib/widgets/show_form.dart';
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
  var forYouBookModels = <BookModel>[]; // for สำหรับคุณ
  var faveritBookModels = <BookModel>[]; // for ยอดนิยม
  var newBookModels = <BookModel>[]; // for มาใหม่

  var docForYouBooks = <String>[];
  var docFaveritBooks = <String>[];
  var docNewBooks = <String>[];

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

        await FirebaseFirestore.instance
            .collection('book')
            .doc(item.id)
            .collection('borrow')
            .get()
            .then((value) {
          if ((value.docs.isNotEmpty)) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            newSearch(),
            const ShowTitle(title: 'สำหรับคุณ'),
            newForYouListView(),
            const ShowTitle(title: 'ยอดนิยม'),
            newFaveritListView(),
            const ShowTitle(title: 'มาใหม่'),
            newListView(),
          ],
        ),
      ),
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
        ShowForm(
          width: 200,
          label: 'Search',
          changeFunc: (String string) {},
        ),
        ShowButton(
          label: 'Search',
          pressFunc: () {},
        ),
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