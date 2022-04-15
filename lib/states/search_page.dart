import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/states/detail_book.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/widgets/show_logo.dart';
import 'package:sulib/widgets/show_text.dart';

class SearchPage extends StatefulWidget {

  final List<BookModel> books;
  final List<String> booksId;

  const SearchPage({
    Key? key,
    required this.books, 
    required this.booksId
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState(books: books, booksId: booksId);
}

class _SearchPageState extends State<SearchPage> {

  final List<BookModel> books;
  final List<String> booksId;

  List<BookModel> queryBooks = [];

  _SearchPageState({required this.books, required this.booksId});

  TextEditingController controllerSearch = TextEditingController();


  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    queryBooks = books;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ค้นหาหนังสือ'),
        backgroundColor: MyContant.primary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8,),
          searchBooks(),
          booksItems()
        ],
      ),
    );
  }

    Widget searchBooks() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      height: 40,
      child: TextField(
        controller: controllerSearch,
        onChanged: (value) {
          String textSearch = value;
          if (textSearch.isEmpty) {
            setState(() {
              queryBooks = books;
            });
          } else {
            setState(() {
              queryBooks = [];
              queryBooks = books.where((map) => map.title.toUpperCase().contains(textSearch.toUpperCase())).toList();
              // print(selectBooks.length);
            });
          }
        },
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            fillColor: Colors.white.withOpacity(0.5),
            filled: true,
            label: const ShowText(text: 'ค้นหาชื่อหนังสือ'),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyContant.dark),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyContant.light),
              borderRadius: BorderRadius.circular(20),
            )),
        cursorColor: MyContant.dark,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget booksItems() {
    return Expanded(
      child: (queryBooks.isEmpty)?
      const Center(
        child: ShowText(text: 'ไม่มีชื่อหนังสือตามที่ค้นหา')
      ) 
      : ListView.builder(
        shrinkWrap: true,
        itemCount: queryBooks.length,
        itemBuilder: (context, index) {
          BookModel book = queryBooks[index];
          return Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: (index == queryBooks.length - 1) ? 16 : 4),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                //Todo Something

                int indexOfBooks = books.indexOf(queryBooks[index]);

                print(indexOfBooks);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DetailBook(
                    bookModel: books[indexOfBooks],
                    docBook: booksId[indexOfBooks],
                  ))
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 150,
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) => const Showlogo(),
                        imageUrl: book.cover
                      ),
                    ),
                    const SizedBox(width: 16,),
                    Flexible(
                      child: Text(
                        book.title,
                        style: TextStyle(
                          color: MyContant.dark,
                          fontSize: 18,
                          fontWeight: FontWeight.normal
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}