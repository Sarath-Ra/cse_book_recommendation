import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/my_recommend_book_page.dart';
import '../pages/new_book_recommend_page.dart';
import '../pages/profile_page.dart';
import '../pages/search_book.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user = FirebaseAuth.instance.currentUser!;

  final List<String> titleName = ['Home', 'Search', 'Profile'];

  int _selectedPageIndex = 0;

  //final searchController = TextEditingController();

  void _selectPage(int index) {
    if (_selectedPageIndex == index) {
      return;
    }
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Future<CollectionReference<Map<String, dynamic>>> getSubColl() async {
    CollectionReference _reference =
        FirebaseFirestore.instance.collection('userCollection');
    QuerySnapshot<Object?> querySnapshot = await _reference
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    DocumentReference<Object?> userRef = querySnapshot.docs[0].reference;
    CollectionReference<Map<String, dynamic>> userSubcollection =
        userRef.collection('myrecomm');
    _reference = userSubcollection;

    return userSubcollection;
  }

  // void setAdminUserData() async {
  //   var status = await OneSignal.shared.getDeviceState();
  //   if (status?.notificationPermissionStatus ==
  //       OSNotificationPermission.authorized) {
  //     print('OneSignal permission granted');
  //   } else {
  //     print('OneSignal permission not granted');
  //   }
  //   String? tokenId = status!.pushToken;

  //   if (status!.subscribed) {
  //     print(
  //         'OneSignal subscribed with user ID: ');
  //   } else {
  //     print('OneSignal not subscribed');
  //   }

  //   await FirebaseFirestore.instance
  //       .collection('admin_data')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .set({
  //         'uid': FirebaseAuth.instance.currentUser!.uid,
  //         'timestamp': DateTime.now().toIso8601String(),
  //         'email': "sarathra25@gmail.com",
  //         'name': "Sarath Ra",
  //         'tokenId': tokenId,
  //         'phone': 9176475511
  //       }).whenComplete(() {
  //         Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  //       })
  //       ;
  // }

  Widget get bottomNavigationBar {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      child: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.amber,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.search),
              label: 'Search'),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.book),
              label: 'Books'),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.person),
              label: 'Profile')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Future<CollectionReference<Map<String, dynamic>>> f =  getSubColl();
    return Scaffold(
      body: _selectedPageIndex == 0
          ? NewRecommendScreen()
          : _selectedPageIndex == 1
              ? SearchPage()
              : _selectedPageIndex == 2
                  ? MyRecommendBookPage()
                  : ProfilePage(),
      bottomNavigationBar: bottomNavigationBar,
      
    );
  }
}
