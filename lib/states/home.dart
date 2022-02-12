import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/states/show_progress.dart';
import 'package:sulib/states/show_title.dart';
import 'package:sulib/utility/my_constant.dart';
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
  var forYouBookmodels = <BookModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllBook();
  }

  Future<void> readAllBook() async {
    await FirebaseFirestore.instance.collection('book').get().then((value) {
      for (var item in value.docs) {
        BookModel bookModel = BookModel.fromMap(item.data());
        setState(() {
          forYouBookmodels.add(bookModel);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            newSearch(),
            const ShowTitle(
              title: "สำหรับคุณ",
            ),
            newForYouListview(),
            const ShowTitle(title: "ยอดนิยม"),
            newForYouListview(),
            const ShowTitle(title: 'มาใหม่'),
            newForYouListview(),
          ],
        ),
      ),
    );
  }

  SizedBox newForYouListview() {
    return SizedBox(
          height: 200,
          child: forYouBookmodels.isEmpty
              ? const ShowProgress()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: forYouBookmodels.length,
                  itemBuilder: (context, index) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 150,
                            child: CachedNetworkImage(
                                errorWidget: (context, url, error) => const Showlogo(),
                                imageUrl: forYouBookmodels[index].cover),
                          ),
                          ShowText(text: forYouBookmodels[index].name),
                        ],
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
          pressFunc: () {},
          label: 'Search',
        ),
      ],
    );
  }
}
