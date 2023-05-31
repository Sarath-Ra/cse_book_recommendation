import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_book_recommendation/pages/admin_home_page.dart';
import 'package:cse_book_recommendation/pages/navigation_on_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import '../screens/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String role = 'user';

  dynamic _checkRole() async {
    User user = FirebaseAuth.instance.currentUser!;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    setState(() {
      role = snap['role'];
    });

    if (role == 'user') {
      return HomePage();
    } else if (role == 'admin') {
      return AdminHome();
    }
  }

  // void navigateNext(Widget route) {
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => route));
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cse-book-recommendation',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }

          if (snapshot.hasData) {
            return HomePage();
          }

          return AuthScreen();
        },
      ),
    );
  }
}
