import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyRecommendBookPage extends StatefulWidget {
  const MyRecommendBookPage({super.key});

  @override
  State<MyRecommendBookPage> createState() => _MyRecommendBookPageState();
}

class _MyRecommendBookPageState extends State<MyRecommendBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.amber,
        title: const Text('Book-Recommendation'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app,
                  color: Colors.amber))
        ],
      ),
      body: Center(child: Text('My Recommend Page')),
    );
  }
}