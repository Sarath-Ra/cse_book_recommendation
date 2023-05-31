import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MoreDetailsPage extends StatelessWidget {
  String? imageUrl;
  String author;
  String title;
  String price;
  String edition;
  MoreDetailsPage(
      {required this.imageUrl,
      required this.author,
      required this.edition,
      required this.price,
      required this.title});

  Widget buildSectionTitle(String text, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget buildContainer(Widget child, BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 150,
        width: 300,
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    // imageUrl = imageUrl ?? "data:image/jpeg;base64,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";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.amber,
        title: Text(
          "BOOK DETAILS",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                if (imageUrl != null)
                  Image.network(
                    imageUrl!,
                    height: 500,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ), // : Icon(Icons.book),
                Positioned(
                    bottom: 20,
                    right: 10,
                    child: Container(
                        width: 250,
                        color: Colors.black54,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 26, color: Colors.white),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        )))
              ],
            ),
            buildSectionTitle('Details', context),
            SingleChildScrollView(
              child: Column(
                children: [
                  Divider(thickness: 5),
                  Container(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(author),
                      subtitle: Text("AUTHOR"),
                    ),
                  ),
                  Divider(thickness: 5),
                  Container(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.type_specimen),
                      ),
                      title: Text(edition),
                      subtitle: Text("EDITION"),
                    ),
                  ),
                  Divider(thickness: 5),
                  Container(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.currency_rupee),
                      ),
                      title: Text(price),
                      subtitle: Text("PRICE"),
                    ),
                  ),
                  Divider(thickness: 5),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
          width: 210,
          child: FloatingActionButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('favourites').add({
                  'uid': user.uid,
                  'imageUrl': imageUrl,
                  'bName': title,
                  'authorName': author,
                  'price': price,
                  'edition': edition,
                  'email': user.email,
                  'createdAt': Timestamp.now(),
                });
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text("Saved book details !!"),
                      );
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Save the book',
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.bookmark_outline,
                    color: Theme.of(context).colorScheme.primary,
                  )
                ],
              ))),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
