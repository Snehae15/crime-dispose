import 'package:crime_dispose/screens/user/Settings.dart';
import 'package:crime_dispose/screens/user/about.dart';
import 'package:crime_dispose/screens/user/myreport.dart';
import 'package:crime_dispose/screens/user/view%20Near%20policestaion.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Name",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Email",
              style: TextStyle(fontSize: 16),
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
                        builder: (context) => const NearPoliceStationPage()),
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
                        builder: (context) => const SettingsPage()),
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
                    MaterialPageRoute(builder: (context) => const About_page()),
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
