import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/admin/Adminaddpolice.dart';
import 'package:crime_dispose/screens/admin/viewaddedpolicestions.dart';
import 'package:crime_dispose/screens/police/all%20case%20view.dart';
import 'package:crime_dispose/screens/screen/landing%20page.dart';
import 'package:flutter/material.dart';

class PoliceStation {
  final String name;
  final String location;
  final String phoneNumber;

  PoliceStation({
    required this.name,
    required this.location,
    required this.phoneNumber,
  });

  factory PoliceStation.fromJson(Map<String, dynamic> json) {
    return PoliceStation(
      name: json['policeStationName'] ?? '',
      location: json['policeStationAddress'] ?? '',
      phoneNumber: json['policePhoneNumber'] ?? '',
    );
  }
}

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<PoliceStation> policeStations = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot =
          await firestore.collection('add_police').get();

      setState(() {
        policeStations = querySnapshot.docs
            .map((doc) =>
                PoliceStation.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Crime Dispose')),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 64,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.add, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Add Police'),
                ],
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminAddPolice(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.view_agenda_outlined, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('View cases'),
                ],
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PoliceViewAllCases(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.list, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('View added police stations'),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewPoliceStations(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.exit_to_app, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LandingPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: policeStations.map((policeStation) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 32,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Police Station Name: ${policeStation.name}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Location: ${policeStation.location}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Colors.green,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Phone Number: ${policeStation.phoneNumber}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
