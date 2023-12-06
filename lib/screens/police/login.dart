import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/police/police%20bottomnavigation.dart';
import 'package:flutter/material.dart';

class PoliceLogin extends StatefulWidget {
  @override
  _PoliceLoginState createState() => _PoliceLoginState();
}

class _PoliceLoginState extends State<PoliceLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Asset/police.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 100),
                      child: Text(
                        'Police Login',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _loginIdController,
                      decoration: const InputDecoration(
                        labelText: 'Login ID',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Login ID';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Perform login logic here
                          String loginId = _loginIdController.text.trim();
                          String password = _passwordController.text.trim();

                          try {
                            // Validate login credentials against Firestore
                            QuerySnapshot querySnapshot =
                                await FirebaseFirestore.instance
                                    .collection('add_police')
                                    .where('policeId', isEqualTo: loginId)
                                    .where('password', isEqualTo: password)
                                    .get();

                            if (querySnapshot.docs.isNotEmpty) {
                              // If login is successful, navigate to the bottom navigation screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PoliceBottomNaviagtion(),
                                ),
                              );
                            } else {
                              // If login fails, show an error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid login credentials'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } catch (e) {
                            print('Error during login: $e');
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
