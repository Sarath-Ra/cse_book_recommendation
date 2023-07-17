import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_book_recommendation/widgets/recom_books.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyRecommendBookPage extends StatefulWidget {
  const MyRecommendBookPage({super.key});

  @override
  State<MyRecommendBookPage> createState() => _MyRecommendBookPageState();
}

class _MyRecommendBookPageState extends State<MyRecommendBookPage> {
  final user = FirebaseAuth.instance.currentUser;
  var yesy = 1;

  void getBooks() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final CollectionReference _usersRef = _db.collection('newbook');
    final Query _query = _usersRef.where('userId', isEqualTo: user!.uid.toString());

    _query.get().then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        setState(() {
          yesy = 0;
        });
      } else {
        print('No documents found.');
      }
    }).catchError((error) {
      print('Error getting document(s): $error');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.amber,
        title: Center(child: const Text('Book-Recommendation')),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app, color: Colors.amber))
        ],
      ),
      body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('newbook')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, bookSnapshots) {
                if (bookSnapshots.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!bookSnapshots.hasData ||
                    bookSnapshots.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No Recommendation found.'),
                  );
                }

                if (bookSnapshots.hasError) {
                  return const Center(
                    child: Text('Something went wrong...'),
                  );
                }

                final loadedBooks = bookSnapshots.data!.docs;

                if (yesy == 1) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.recommend,
                          size: 100,
                          color: Colors.grey[600],
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: 100,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Recommend new books to enhance the regulation book',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            )),
                        Text(
                          'My recommendations',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: loadedBooks.length,
                  itemBuilder: (ctx, index) {
                    final book = loadedBooks[index].data();

                    final sameUser = user!.uid == book['userId'];

                    Timestamp timestamp = book['createdAt'];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate =
                        "${dateTime.day}/${dateTime.month}/${dateTime.year}";
                    String formattedTime =
                        "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";

                    if (sameUser) {
                      return RecomBooks(
                        name: book['courseCode&No'],
                        newbook: book['bookName'],
                        author: book['authorName'],
                        price: book['price'],
                        edition: book['editionNo'],
                        date: formattedDate,
                        time: formattedTime,
                        isApproved: book['isAproved'],
                      );
                    }
                  },
                );
              },
            ),
        
    );
  }
}
