import 'package:crime_dispose/screens/user/userBottomnavigation.dart';
import 'package:crime_dispose/screens/user/userregister1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserLog extends StatefulWidget {
  const UserLog({super.key});

  @override
  State<UserLog> createState() => _UserLogState();
}

class _UserLogState extends State<UserLog> {
  var email = TextEditingController();
  var password = TextEditingController();
  bool isPasswordVisible = false;

  bool _validateFields() {
    if (email.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter email');
      return false;
    }
    if (password.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter password');
      return false;
    }
    return true;
  }

  Future<void> loginUser() async {
    if (!_validateFields()) return;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      // If login is successful, show toast message and navigate to the user home screen
      if (userCredential.user != null) {
        Fluttertoast.showToast(msg: 'Login successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const UserBottomNavigations()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Wrong password provided for that user.');
      } else {
        Fluttertoast.showToast(msg: 'Error: ${e.message}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) {
            var screenSize = MediaQuery.of(context).size;

            return SingleChildScrollView(
              child: Container(
                width: screenSize.width,
                height: screenSize.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(0, 64, 63, 62),
                      Colors.white,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: screenSize.height * 0.2),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "CRIME",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "DISPOSE",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Icon(Icons.person,
                                size: 60, color: Colors.black),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height * 0.10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  controller: email,
                                  style: const TextStyle(color: Colors.grey),
                                  decoration: InputDecoration(
                                    hintText: "E-mail",
                                    prefixIcon: const Icon(Icons.email,
                                        color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  controller: password,
                                  style: const TextStyle(color: Colors.grey),
                                  obscureText: !isPasswordVisible,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    prefixIcon: const Icon(Icons.lock,
                                        color: Colors.grey),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              InkWell(
                                onTap: () {
                                  loginUser();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.grey, Colors.grey],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  width: 130,
                                  height: 50,
                                  child: const Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UserRegister(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Don't have an account? Sign up",
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),

                              // if (email.text.isNotEmpty &&
                              //     password.text.isNotEmpty)
                              //   const Padding(
                              //     padding: EdgeInsets.all(8.0),
                              //     child: Text(
                              //       "Incorrect email or password",
                              //       style: TextStyle(
                              //         color: Colors.red,
                              //         fontSize: 16,
                              //       ),
                              //     ),
                              //   ),

                              // TextButton(
                              //   onPressed: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) {
                              //           return NewPassword();
                              //         },
                              //       ),
                              //     );
                              //   },
                              //   child: const Text("Forgot Password?"),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
