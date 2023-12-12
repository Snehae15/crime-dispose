import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/user/userhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyReport extends StatefulWidget {
  const MyReport({super.key});

  @override
  State<MyReport> createState() => _MyReportState();
}

class _MyReportState extends State<MyReport> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> fetchUserCases() async {
    try {
      User? user = _auth.currentUser;
      print('Current user: $user');

      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('add_case')
            .where('userId', isEqualTo: user.uid)
            .get();

        print('Query result: ${querySnapshot.docs.length} documents');

        return querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      } else {
        print('User is null');
        return [];
      }
    } catch (e, stackTrace) {
      print('Error fetching user cases: $e');
      print(stackTrace);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUserCases(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          List<Map<String, dynamic>> cases = snapshot.data ?? [];

          return Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "My Cases",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: cases.length,
                  itemBuilder: (context, index) {
                    String caseName =
                        cases[index]['caseName'] ?? 'Unknown Case';
                    String location = cases[index]['location'] ?? '';
                    return _buildCaseCard(cases[index], caseName, location);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCaseCard(
      Map<String, dynamic> caseData, String caseName, String location) {
    return Card(
      child: ListTile(
        title: const Padding(
          padding: EdgeInsets.only(top: 20, right: 150),
          child: Icon(Icons.location_on_outlined, size: 15),
        ),
        subtitle: Text(location),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CaseDetails(
                  caseType: caseData['caseType'] ?? '',
                  location: location,
                  title: caseName,
                  date: caseData['date'] ?? '',
                  time: caseData['time'] ?? '',
                  description: caseData['description'] ?? '',
                  imageUrl: caseData['imageUrl'] ?? '',
                ),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 25),
            child: Text("more"),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Text(
            caseName,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
