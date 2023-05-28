import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NewRecommendScreen extends StatefulWidget {
  const NewRecommendScreen({super.key});

  @override
  State<NewRecommendScreen> createState() => _NewRecommendScreenState();
}

class _NewRecommendScreenState extends State<NewRecommendScreen> {
  final _formKeyNewBook = GlobalKey<FormState>();

  var _enteredBookName = '';
  var _enteredAuthorName = '';
  var _enteredEditionNo = '';
  var _enteredPrice = '';

  var _isSubmitting = false;

  String? _dropDownValueCourseCode = 'Course Code';
  String? _dropDownisCousrseName = "Course Name";

  final List<String> _typeListCourseCode = ['Course Code', '19Z402', "19Z404"];

  final List<String> _typeListCourseName = [
    "Course Name",
    "DBMS",
    "Operating Systems",
  ];

  void _submit() async {
    final isValid = _formKeyNewBook.currentState!.validate();

    if (!isValid) {
      // show error message
      return;
    }

    _formKeyNewBook.currentState!.save();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book-Recommendation'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary))
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
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
                    child: Form(
                      key: _formKeyNewBook,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            width: MediaQuery.of(context).size.width * 0.87,
                            child: Center(
                              child: DropdownButton(
                                isDense: true,
                                alignment: Alignment.centerLeft,
                                isExpanded: true,
                                iconSize: 40,
                                iconEnabledColor: Theme.of(context).colorScheme.primary,
                                value: _dropDownValueCourseCode,
                                onChanged: (newValue) {
                                  setState(() {
                                    _dropDownValueCourseCode = newValue;
                                  });
                                },
                                items: _typeListCourseCode
                                    .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 20),
                                        )))
                                    .toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            width: MediaQuery.of(context).size.width * 0.87,
                            child: Center(
                              child: DropdownButton(
                                isDense: true,
                                alignment: Alignment.centerLeft,
                                isExpanded: true,
                                // disabledHint: Text("VAFI"),
                                iconSize: 40,
                                iconEnabledColor: Theme.of(context).colorScheme.primary,
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
                                              fontWeight: FontWeight.bold, fontSize: 20),
                                        )))
                                    .toList(),
                              ),
                            ),
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'New Book Name'),
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please Enter Book Name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredBookName = value!;
                            },
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Author Name'),
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please Enter Author Name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredAuthorName = value!;
                            },
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Edition No.'),
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  int.parse(value.trim()) < 1 ||
                                  int.parse(value.trim()) > 15) {
                                return 'Please Enter a Valid Edition No';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEditionNo =
                                  int.parse(value!.trim()) as String;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Price'),
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  int.parse(value.trim()) < 1 ||
                                  int.parse(value.trim()) > 10000) {
                                return 'Please Enter a Valid Price';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPrice =
                                  int.parse(value!.trim()) as String;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (_isSubmitting) const CircularProgressIndicator(),
                          if (!_isSubmitting)
                            ElevatedButton(
                                onPressed: _submit,
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
              ),
            ],
          ),
        ),
    
    );
  }
}
