import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_book_recommendation/pages/admin_home_page.dart';
import 'package:cse_book_recommendation/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavigationOnUser extends StatefulWidget {
  const NavigationOnUser({super.key});

  @override
  State<NavigationOnUser> createState() => _NavigationOnUserState();
}

class _NavigationOnUserState extends State<NavigationOnUser> {
  String role = 'user';

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  void _checkRole() async {
    User user = FirebaseAuth.instance.currentUser!;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    setState(() {
      role = snap['role'];
    });

    if (role == 'user') {
      navigateNext(HomePage());
    } else if (role == 'admin') {
      navigateNext(AdminHome());
    }
  }

  void navigateNext(Widget route) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => route));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome'), 
            ],
          ),
        ),
      );
  }
}
