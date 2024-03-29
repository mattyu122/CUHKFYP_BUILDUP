// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  bool HidePassword = true;
  bool? isChecked = false;
  final email = TextEditingController();
  bool isEmailSent = false;
  @override
  Widget build(BuildContext context) {
    final urlImage = "https://cdn-icons-png.flaticon.com/512/6133/6133890.png";
    return Scaffold(
      appBar: new AppBar(
        toolbarHeight: 42,
        backgroundColor: Color.fromARGB(255, 119, 20, 244),
      ),
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 145),
              child: Column(children: [
                SizedBox(height: 44),
                Text(
                  'B u i l d  U P',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 53.0,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 22.0,
                  ),
                ),
                SizedBox(height: 23.0),
                Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 19.0,
                  ),
                ),

                Column(
                  children: [
                    Image.network(
                      urlImage,
                      height: 200,
                      width: 200,
                    )
                  ],
                ),

                SizedBox(height: 25.0),

                //Email TextField,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 181, 156, 255),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          controller: email,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            hintText: "Enter your email",
                            hintStyle: TextStyle(
                                fontSize: 17.0,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                //Message(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        '* We will send you a message to set or reset   your new password',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 50),

                //SendEmail()
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                      child: Column(
                    children: [
                      if (isEmailSent) ...[
                        Text(
                          "Reset password email is sent, please check",
                          style: TextStyle(
                              color: Color.fromARGB(255, 185, 89, 240),
                              fontSize: 17),
                        )
                      ],
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(360, 50),
                            backgroundColor: Color.fromARGB(255, 181, 156, 255),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        onPressed: sendForgotPasswordEmail,
                        child: Text(
                          'Send Email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void sendForgotPasswordEmail() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email.text.trim());
    setState(() {
      isEmailSent = true;
    });
  }
}
