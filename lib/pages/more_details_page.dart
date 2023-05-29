import 'package:flutter/material.dart';

class MoreDetailsPage extends StatelessWidget {
  String imageUrl;
  String author;
  String title;
  String price;
  String edition;
  MoreDetailsPage({required this.imageUrl, required this.author, required this.edition, required this.price, required this.title});

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
                  Image.network(
                    imageUrl,
                    height: 250,
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
                          child: Icon(Icons.price_change),
                        ),
                        title: Text(author),
                        subtitle: Text("AUTHOR"),
                      ),
                    ),
                    Divider(thickness: 5),
                    Container(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.location_city),
                        ),
                        title: Text(edition),
                        subtitle: Text("EDITION"),
                      ),
                    ),
                    Divider(thickness: 5),
                    Container(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.type_specimen),
                        ),
                        title: Text(price),
                        subtitle: Text("PRICE"),
                      ),
                    ),
                    
                    Divider(thickness: 5),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
