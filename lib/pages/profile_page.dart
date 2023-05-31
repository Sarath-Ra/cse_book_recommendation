import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      return snapshot;
    }
    throw Exception('User not logged in');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: fetchUserData(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No data available');
        }

        // Data is available, extract the username and email
        String username = snapshot.data!.get('username') ?? '';
        String email = snapshot.data!.get('email') ?? '';

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'assets/image/profile_image.png'), // Replace with your own image
                    ),
                    SizedBox(height: 10),
                    Text(
                      username,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Favorite Books',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   itemCount: favoriteBooks.length,
                    //   itemBuilder: (context, index) {
                    //     return ListTile(
                    //       leading: Icon(Icons.book),
                    //       title: Text(favoriteBooks[index]),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('favourites')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (ctx, bookSnapshots) {
                    if (bookSnapshots.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!bookSnapshots.hasData ||
                        bookSnapshots.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No favourites found...'),
                      );
                    }

                    if (bookSnapshots.hasError) {
                      return const Center(
                        child: Text('Something went wrong...'),
                      );
                    }

                    final loadedBooks = bookSnapshots.data!.docs;

                    if (loadedBooks.isEmpty) {
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

                        final sameUser = user.uid == book['userId'];
  
                        Timestamp timestamp = book['createdAt'];
                        DateTime dateTime = timestamp.toDate();
                        String formattedDate =
                            "${dateTime.day}/${dateTime.month}/${dateTime.year}";
                        String formattedTime =
                            "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";

                        if (sameUser) {
                          Container(
                            height: 200,
                            width: 200,
                            child: Card(),
                          );
                        }
                      },
                    );
                  },
                ),
              )
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
