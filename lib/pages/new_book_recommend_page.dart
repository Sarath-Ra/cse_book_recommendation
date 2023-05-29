import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NewRecommendScreen extends StatefulWidget {
  const NewRecommendScreen({super.key});

  @override
  State<NewRecommendScreen> createState() => _NewRecommendScreenState();
}

class _NewRecommendScreenState extends State<NewRecommendScreen> {
  var _isSubmitting = false;

  final _newBookNameController = TextEditingController();
  final _authorNameController = TextEditingController();
  final _bookPriceController = TextEditingController();
  final _editionController = TextEditingController();

  String? _dropDownisCousrseName = "Course Name";

  final user = FirebaseAuth.instance.currentUser!;

  final List<String> _typeListCourseName = [
    "Course Name",
    "19Z104 - Problem Solving and Python Programming",
    "19Z111 - Engineering Practices",
    "19Z112 - Python Programming Laboratory",
    "19Z204 - Digital Design",
    "19Z205 - C Programming",
    "19Z211 - Digital Design Laboratory",
    "19Z302 - Data Structures",
    "19Z303 - Computer Architecture",
    "19Z305 - Object Oriented Programming",
    "19Z310 - Data Structures Laboratory",
    "19Z311 - Object Oriented Programming Laboratory",
    "19Z402 - Design and Analysis of Algorithms",
    "19Z403 - Operating Systems",
    "19Z404 - Database Management Systems",
    "19Z405 - Software Engineering",
    "19Z410 - Operating Systems Laboratory",
    "19Z411 - Database,Management Systems Laboratory",
    "19Z501 - Theory of Computing",
    "19Z502 - Microprocessors and Interfacing",
    "19Z503 - Artificial Intelligence",
    "19Z504 - Computer Networks",
    "19Z505 - Object oriented Analysis and Design",
    "19Z510 - Computer Networks Laboratory",
    "19Z511 - Microprocessors and Interfacing Laboratory",
    "19Z601 - Machine Learning",
    "19Z602 - Compiler Design",
    "19Z603 - Distributed Computing",
    "19Z604 - Embedded Systems",
    "19Z610 - Machine Learning Laboratory",
    "19Z611 - Distributed Computing Laboratory",
    "19Z612 - Application Development Laboratory",
    "19Z701 - Cryptography"
  ];

  @override
  void dispose() {
    _newBookNameController.dispose();
    _authorNameController.dispose();
    _bookPriceController.dispose();
    _editionController.dispose();
    super.dispose();
  }

  Future _submit(
      {required String courseName,
      required String newBook,
      required String authorName,
      required int price,
      required int editionNo,
      required Timestamp createdAt,
      required String id,
      required String facultyName,
      required String facultyEmail}) async {
    if (_newBookNameController.text.isEmpty ||
        _editionController.text.isEmpty ||
        _authorNameController.text.isEmpty ||
        _bookPriceController.text.isEmpty ||
        _dropDownisCousrseName == "Course Name") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Enter all the Details and Then Recommend"),
            );
          });
      return;
    }

    await FirebaseFirestore.instance.collection('NewBook').add({
      'courseCode&No': courseName,
      'bookName': newBook,
      'authorName': authorName,
      'editionNo': editionNo,
      'price': price,
      'createdAt': createdAt,
      'userId': id,
      'username': facultyName,
      'userEmail': facultyEmail,
      'isAproved': false
    });

    FocusScope.of(context).unfocus();
    _newBookNameController.clear();
    _authorNameController.clear();
    _bookPriceController.clear();
    _editionController.clear();
    setState(() {
      _dropDownisCousrseName = 'Course Name';
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("New Book Recommended !!"),
        );
      });

    // setState(() {
    //   _isSubmitting = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book-Recommendation'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.amber,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app,
                  color: Colors.amber))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Recommend New Book!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: MediaQuery.of(context).size.width * 0.89,
                        child: Center(
                          child: DropdownButton(
                            isDense: true,
                            alignment: Alignment.centerLeft,
                            isExpanded: true,
                            // disabledHint: Text("VAFI"),
                            iconSize: 40,
                            iconEnabledColor:
                                Theme.of(context).colorScheme.primary,
                            value: _dropDownisCousrseName,
                            onChanged: (newValue) {
                              setState(() {
                                _dropDownisCousrseName = newValue;
                              });
                            },
                            items: _typeListCourseName
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.grey[800]),
                                    )))
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: MediaQuery.of(context).size.width * 0.89,
                        child: Center(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: _newBookNameController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'New Book Name',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.grey[800])),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: MediaQuery.of(context).size.width * 0.89,
                        child: Center(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: _authorNameController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Author Name',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.grey[800])),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: MediaQuery.of(context).size.width * 0.89,
                        child: Center(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _editionController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Edition No.',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.grey[800])),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: MediaQuery.of(context).size.width * 0.89,
                        child: Center(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _bookPriceController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Price',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.grey[800])),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (_isSubmitting) const CircularProgressIndicator(),
                      if (!_isSubmitting)
                        ElevatedButton(
                            onPressed: () async {
                              final userData = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .get();
                              _submit(
                                  courseName: _dropDownisCousrseName.toString(),
                                  newBook: _newBookNameController.text.trim(),
                                  authorName: _authorNameController.text.trim(),
                                  price: int.parse(
                                      _bookPriceController.text.trim()),
                                  editionNo:
                                      int.parse(_editionController.text.trim()),
                                  createdAt: Timestamp.now(),
                                  id: user.uid,
                                  facultyName: userData.data()!['username'],
                                  facultyEmail: userData.data()!['email']);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            child: Text('RECOMMEND')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
