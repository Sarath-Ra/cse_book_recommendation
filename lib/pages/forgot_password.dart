import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Password reset link sent! Check"),
          );
        }
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.amber,
        title: Text("Forgot Password", style: TextStyle(color: Colors.amber),),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Center(
          //     child: Text(
          //   "Enter Your Email and we will send you a password reset link",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(fontSize: 20),
          // )),
          Icon(
                    Icons.reset_tv_sharp,
                    size: 100,
                    color: Colors.grey[600],
                  ),
          Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 70,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Enter Your Email and we will send you a password reset link",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      )),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Email'),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
                                onPressed: passwordReset,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                child: Text('Reset Password')),
        ],
      ),
    );
  }
}
