import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sulib/mdels/reserve_model.dart';
import 'package:sulib/mdels/user_model.dart';
import 'package:sulib/states/basket_summary.dart';
// import 'package:sulib/states/ecard.dart';
import 'package:sulib/states/history.dart';
import 'package:sulib/states/home.dart';
import 'package:sulib/states/review.dart';
// import 'package:sulib/states/noti.dart';
// import 'package:sulib/states/review.dart';
import 'package:sulib/states/show_list_recive_book.dart';
import 'package:sulib/utility/my_constant.dart';

class MyService extends StatefulWidget {
  const MyService({
    Key? key,
  }) : super(key: key);

  @override
  State<MyService> createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {

  var bottomNavigationBarItems = <BottomNavigationBarItem>[];
  var titles = <String>[
    'Home',
    'History',
    'Review',
    // 'Ecard',
    // 'Noti',
  ];

  var iconDatas = <IconData>[
    Icons.home,
    Icons.history,
    Icons.reviews,
    // // Icons.card_membership,
    // // Icons.notifications,
  ];

  var widgets = <Widget>[
    const Home(),
    const History(),
    const Review(),
    // const Review(),
    // // const Ecard(),
    // // const Noti(),
  ];
  int indexWidget = 0;

  FlutterLocalNotificationsPlugin flutterLocalNotiPlugin =
      FlutterLocalNotificationsPlugin();
  InitializationSettings? initializationSettings;
  AndroidInitializationSettings? androidInitializationSettings;

  var reserveModels = <ReserveModel>[];
  Timestamp? nearestTimeNoti;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int i = 0;
    for (var item in iconDatas) {
      BottomNavigationBarItem bottomNavigationBarItem = BottomNavigationBarItem(
        backgroundColor: Colors.blueGrey,
        icon: Icon(item),
        label: titles[i],
      );
      bottomNavigationBarItems.add(bottomNavigationBarItem);

      i++;
    }
    setupLocalNoti();
    findTimeForNoti();
  }

  Future<void> findTimeForNoti() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(event!.uid)
          .collection("reserve")
          .orderBy("endDate")
          .get()
          .then((value) async {
        for (var item in value.docs) {
          ReserveModel reserveModel = ReserveModel.fromMap(item.data());
          reserveModels.add(reserveModel);
        }

        nearestTimeNoti = reserveModels[0].endDate;
        print("เวลาใกล้สุด ===> ${nearestTimeNoti!.toDate().toString()}");

        DateTime currentDateTime = DateTime.now();
        DateTime nearestDateTime = nearestTimeNoti!.toDate();

        var diff = nearestDateTime.difference(currentDateTime);
        print("เวลาที่ diff กัน --->>>> ${diff.inDays}");
        

        if (diff.inDays > 0 && diff.inDays <= 2) {
          Duration duration = Duration(seconds: 5);
          await Timer(
              duration,
              () => processDisplayNoti("หนังสือที่ท่านจองว่างแล้ว",
                  "หนังสือ ${reserveModels[0]} จะมาอีกภายใน 2 วัน ${diff.inDays} ครับ"));
        }
      });
    });
  }

  Future<void> setupLocalNoti() async {
    androidInitializationSettings =
        const AndroidInitializationSettings("app_icon");
    initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotiPlugin.initialize(
      initializationSettings!,
      onSelectNotification: onSelectNoti,
    );
  }

  Future<void> onSelectNoti(String? string) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ShowListReceiveBook(),
        ));
  }

  Future<void> processDisplayNoti(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "channelId",
      "channelName",
      priority: Priority.high,
      importance: Importance.max,
      ticker: "ticker",
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotiPlugin.show(0, title, body, notificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // IconButton(
          //     onPressed: () =>
          //         processDisplayNoti("หัวข้อทดสอบ", "รายละเอียดทดสอบ"),
          //     icon: Icon(Icons.android)),
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => BasketSummary())),
            icon: const Icon(Icons.shopping_cart)
          ),
          const SizedBox(width: 16,),
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) =>
                    Navigator.pushNamedAndRemoveUntil(
                        context, MyContant.routeAuthen, (route) => false));
              },
              icon: const Icon(Icons.logout))
        ],
        backgroundColor: MyContant.primary,
        title: const Text('My Service'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            indexWidget = value;
          });
        },
        currentIndex: indexWidget,
        items: bottomNavigationBarItems,
      ),
      body: widgets[indexWidget],
    );
  }
}
