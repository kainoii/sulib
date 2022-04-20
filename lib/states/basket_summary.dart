import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sulib/mdels/address.dart';
import 'package:sulib/mdels/book-model.dart';
import 'package:sulib/states/address_form.dart';
import 'package:sulib/states/address_list.dart';
import 'package:sulib/utility/my_constant.dart';
import 'package:sulib/widgets/dismissible_widget.dart';

class BasketSummary extends StatefulWidget {
  const BasketSummary({Key? key}) : super(key: key);

  @override
  State<BasketSummary> createState() => _BasketSummaryState();
}

class _BasketSummaryState extends State<BasketSummary> {
  
  final List<BookModel> booksList = [
    BookModel(
        cover: 'https://firebasestorage.googleapis.com/v0/b/sulibary.appspot.com/o/cover%2Fkm06.jpg?alt=media&token=1c86a9fd-217d-44fe-9d7c-f9bbbe3f52ec',
        isbnNumber: '9786163810823',
        publisher: 'บริษัทอินส์พัล',
        author: 'บุญร่วม เทียมจันทร์ และ ศรัญญา วิชชาธรรม',
        bookCatetory: 'กฎหมาย',
        bookCode: '02007510',
        detail: 'อัพเดตรัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 ทั้ง 279 มาตรา พร้อมรวบรวมหัวข้อเรื่องทุกมาตรา จับประเด็นง่ายและชัดเจน!',
        numberOfPage: '258',
        title: 'รัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 พร้อมหัวข้อเรื่องทุกมาตรา ฉบับสมบูรณ์',
        yearOfImport: '2018-04-10'
    ),
    BookModel(
        cover: 'https://firebasestorage.googleapis.com/v0/b/sulibary.appspot.com/o/cover%2Fkm08.jpg?alt=media&token=aeaefc78-2eb7-4cd1-aa01-d45469c3757f',
        isbnNumber: '9786163810823',
        publisher: 'บริษัทอินส์พัล',
        author: 'บุญร่วม เทียมจันทร์ และ ศรัญญา วิชชาธรรม',
        bookCatetory: 'กฎหมาย',
        bookCode: '02007510',
        detail: 'อัพเดตรัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 ทั้ง 279 มาตรา พร้อมรวบรวมหัวข้อเรื่องทุกมาตรา จับประเด็นง่ายและชัดเจน!',
        numberOfPage: '258',
        title: 'รัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 พร้อมหัวข้อเรื่องทุกมาตรา ฉบับสมบูรณ์',
        yearOfImport: '2018-04-10'
    ),
    BookModel(
        cover: 'https://firebasestorage.googleapis.com/v0/b/sulibary.appspot.com/o/cover%2Ftr01.jpg?alt=media&token=9534e0c4-90b0-4200-aa5e-a33e9e81c083',
        isbnNumber: '9786163810823',
        publisher: 'บริษัทอินส์พัล',
        author: 'บุญร่วม เทียมจันทร์ และ ศรัญญา วิชชาธรรม',
        bookCatetory: 'กฎหมาย',
        bookCode: '02007510',
        detail: 'อัพเดตรัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 ทั้ง 279 มาตรา พร้อมรวบรวมหัวข้อเรื่องทุกมาตรา จับประเด็นง่ายและชัดเจน!',
        numberOfPage: '258',
        title: 'รัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 พร้อมหัวข้อเรื่องทุกมาตรา ฉบับสมบูรณ์',
        yearOfImport: '2018-04-10'
    ),
    BookModel(
        cover: 'https://firebasestorage.googleapis.com/v0/b/sulibary.appspot.com/o/cover%2Fkm09.jpg?alt=media&token=7b24e14e-eeeb-4dcf-b11d-1c85d6321000',
        isbnNumber: '9786163810823',
        publisher: 'บริษัทอินส์พัล',
        author: 'บุญร่วม เทียมจันทร์ และ ศรัญญา วิชชาธรรม',
        bookCatetory: 'กฎหมาย',
        bookCode: '02007510',
        detail: 'อัพเดตรัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 ทั้ง 279 มาตรา พร้อมรวบรวมหัวข้อเรื่องทุกมาตรา จับประเด็นง่ายและชัดเจน!',
        numberOfPage: '258',
        title: 'รัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 พร้อมหัวข้อเรื่องทุกมาตรา ฉบับสมบูรณ์',
        yearOfImport: '2018-04-10'
    ),
    BookModel(
        cover: 'https://firebasestorage.googleapis.com/v0/b/sulibary.appspot.com/o/cover%2Ftr02.jpg?alt=media&token=e61bbc9b-262f-4d6d-b106-2c7706a12e41',
        isbnNumber: '9786163810823',
        publisher: 'บริษัทอินส์พัล',
        author: 'บุญร่วม เทียมจันทร์ และ ศรัญญา วิชชาธรรม',
        bookCatetory: 'กฎหมาย',
        bookCode: '02007510',
        detail: 'อัพเดตรัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 ทั้ง 279 มาตรา พร้อมรวบรวมหัวข้อเรื่องทุกมาตรา จับประเด็นง่ายและชัดเจน!',
        numberOfPage: '258',
        title: 'รัฐธรรมนูญแห่งราชอาณาจักรไทย พุทธศักราช 2560 พร้อมหัวข้อเรื่องทุกมาตรา ฉบับสมบูรณ์',
        yearOfImport: '2018-04-10'
    ),
  ];

  late Address? addressSend;

  @override
  void initState() {
    super.initState();
    addressSend = Address(
      id: "0",
      firstName: "สมชาย1",
      lastname: "ล่ายปี้เอ๋งเอ๋ง",
      phone: "0908745548",
      building: "Super Condo",
      addressNumber: "12/34",
      moo: "2",
      soi: "5",
      street: "ศักดิ์ดิเรท",
      subDistrict: "ศรีราชา",
      district: "แมกล่อง",
      province: "สมุทรปราการ",
      zipCode: "78452",
      isDefault: true
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการยืมหนังสือ'),
        backgroundColor: MyContant.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: booksList.isNotEmpty
        ? ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 16,),
            buildTextAddress(),
            buildSummaryBook(),
            buildButtonBorrow()
          ],
        )
        : buildEmptyBasket()
      ),
    );
  }

  Widget buildTextAddress() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ที่อยู่จัดส่ง',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: MyContant.black
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddressList())),
                child: Text(
                  'เลือกที่อยู่ใหม่',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MyContant.dark,
                    decoration: TextDecoration.underline
                  ),
                )
              )
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${addressSend!.getName()} ',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black
                        ),
                      ),
                      Text(
                        'โทร ${addressSend!.phone}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black
                        ),
                      ),
                      (addressSend!.building != null)
                      ? Text(
                        '${addressSend!.building}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black
                        ),
                      )
                      : Container(),
                      Text(
                        addressSend!.getAddressSummary(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddressForm(addressUser: addressSend,))),
                icon: const Icon(Icons.edit)
              )
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget buildSummaryBook() {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 16,),
          Text(
            'สรุปรายการสั่งซื้อ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: MyContant.black
            ),
          ),
          const Divider(),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: booksList.length,
            itemBuilder: (context, index) {
              BookModel bookModel = booksList[index];
              return DismissibleWidget(
                item: bookModel,
                child: buildBookItemWidget(bookModel),
                onDismissed: (direction) =>
                  dismissItem(context, index, direction),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildEmptyBasket() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16,),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MyContant.dark, width: 5)
              ),
              child: Icon(
                Icons.remove_shopping_cart,
                color: MyContant.dark,
                size: 70,
              ),
            ),
          ),
          const SizedBox(height: 32,),
          Text(
            'ไม่มีรายการหนังสือที่คุณต้องการยืม',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MyContant.dark
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  void dismissItem(
      BuildContext context,
      int index,
      DismissDirection direction
  ) {
    setState(() {
      booksList.removeAt(index);
    });
  }

  Widget buildBookItemWidget(BookModel bookModel) {

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        child: CachedNetworkImage(
          imageUrl: bookModel.cover,
          width: 40,
          height: 120,
          fit: BoxFit.contain,
        ),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0,3),
                  blurRadius: 5,
                  spreadRadius: 1,
                  color: Colors.grey.withOpacity(0.5)
              )
            ]
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          bookModel.title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Text(
        'ISBN: ${bookModel.isbnNumber}',
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget buildButtonBorrow() {
    return Column(
      children: [
        const SizedBox(height: 16,),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: MyContant.dark,
            onPrimary: Colors.white,
            elevation: 2,
            shadowColor: Colors.grey.shade600,
            minimumSize: const Size.fromHeight(50)
          ),
          onPressed: () {},
          child: const Text(
            'ยืมหนังสือ',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20
            ),
          ),
        ),
        const SizedBox(height: 32,)
      ],
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
