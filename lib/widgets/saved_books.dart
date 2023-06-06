import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../pages/admin_home_page.dart';

class SavedBooks extends StatelessWidget {
  String newbook;
  String author;
  String price;
  String edition;
  String date;
  String time;
  String imageUrl;
  SavedBooks(
      {required this.newbook,
      required this.author,
      required this.price,
      required this.edition,
      required this.date,
      required this.time,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return FullDetails();
          // }));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 20,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color.fromARGB(255, 137, 71, 218)),
              ),
              child: Column(
                // shrinkWrap: true,
                children: [
                  
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text(
                      newbook,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      author,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Icon(Icons.type_specimen),
                            
                            Text(
                              edition.toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            
                            Text(
                              price.toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: ListTile(
                      title: Column(
                        children: [
                          Text(
                            'Saved at',
                            style: TextStyle(fontSize: 15),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    date,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.punch_clock),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    time,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Add more rows as needed
                ],
              ),
            ),
          ),
        ));
  }
}
