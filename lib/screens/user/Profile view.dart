import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/screen/landing%20page.dart';
import 'package:crime_dispose/screens/user/Settings.dart';
import 'package:crime_dispose/screens/user/about.dart';
import 'package:crime_dispose/screens/user/myreport.dart';
import 'package:crime_dispose/screens/user/view%20Near%20policestaion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<User?>(
              future: Future.value(_auth.currentUser),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                User? user = snapshot.data;

                if (user == null) {
                  return const Text('User not found');
                }

                return FutureBuilder<DocumentSnapshot>(
                  future: _firestore.collection('users').doc(user.uid).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    var userData = snapshot.data?.data();
                    var firstName = userData != null
                        ? (userData as Map<String, dynamic>)['firstName'] ??
                            'N/A'
                        : 'N/A';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: $firstName",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Email: ${user.email ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text("My Reports"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyReport()),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Nearby Stations"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NearPoliceStationPage(),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Settings"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("About Us"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const About_page(),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Log Out"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LandingPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
