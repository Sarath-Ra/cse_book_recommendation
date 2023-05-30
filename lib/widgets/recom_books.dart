import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../pages/full_details.dart';

class RecomBooks extends StatelessWidget {
  String name;
  String newbook;
  String author;
  int price;
  int edition;
  String date;
  String time;
  bool isApproved;
  RecomBooks(
      {required this.name,
      required this.newbook,
      required this.author,
      required this.price,
      required this.edition,
      required this.date,
      required this.time,
      required this.isApproved});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return FullDetails();
          // }));
        },
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
                if (isApproved)
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                  elevation: 6,
                  color: Colors.greenAccent[400],
                  child: Container(
                    height: 40,
                    // color: Colors.greenAccent[400],
                    child: Center(
                        child: Text(
                      'APPROVED',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    )),
                  ),
                ),
                if (!isApproved)
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                  elevation: 6,
                  color: Colors.yellowAccent[400],
                  child: Container(
                    height: 40,
                    // color: Colors.greenAccent[400],
                    child: Center(
                        child: Text(
                      'WAITING',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    )),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.subject),
                  title: Text(
                    name,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
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
                            'Edition: ',
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            edition.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.currency_rupee),
                          SizedBox(
                            width: 10,
                          ),
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
                          'Recommend Time',
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
        ));
  }
}
