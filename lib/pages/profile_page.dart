import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_book_recommendation/widgets/saved_books.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/recom_books.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var uname = '';
  var uemail = '';
  var yes = 1;

  void getbooks() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final CollectionReference _usersRef = _db.collection('favourites');
    final Query _query =
        _usersRef.where('uid', isEqualTo: user.uid.toString());

    _query.get().then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        setState(() {
          yes = 0;
        });
      } else {
        print('No documents found.');
      }
    }).catchError((error) {
      print('Error getting document(s): $error');
    });
  }

  void fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      setState(() {
        uname = snapshot.data()!['username'];
        uemail = snapshot.data()!['email'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
    getbooks();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
            icon: Icon(Icons.exit_to_app, color: Colors.amber),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
              ),
              const Text(
                "Profile",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(
                'assets/image/profile_image.png'), // Replace with your own image
          ),
          SizedBox(height: 10),
          Text(
            uname,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            uemail,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Saved!",
            style: GoogleFonts.bebasNeue(
              fontSize: 54,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('favourites')
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
                    child: Text('No Favourites found.'),
                  );
                }

                if (bookSnapshots.hasError) {
                  return const Center(
                    child: Text('Something went wrong...'),
                  );
                }

                final loadedBooks = bookSnapshots.data!.docs;

                if (yes == 1) {
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
                                'Save books for later reference',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            )),
                        Text(
                          'Saved books',
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

                    final sameUser = user!.uid == book['uid'];

                    Timestamp timestamp = book['createdAt'];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate =
                        "${dateTime.day}/${dateTime.month}/${dateTime.year}";
                    String formattedTime =
                        "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";

                    if (sameUser) {
                      return SavedBooks(
                        newbook: book['bName'],
                        author: book['authorName'],
                        price: book['price'],
                        edition: book['edition'],
                        date: formattedDate,
                        time: formattedTime,
                        imageUrl: book['imageUrl'],
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
          width: 110,
          child: FloatingActionButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.primary,
                  )
                ],
              ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
