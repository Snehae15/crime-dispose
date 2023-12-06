import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/user/missing%20cases%20view.dart';
import 'package:flutter/material.dart';

class MyReport extends StatefulWidget {
  const MyReport({Key? key}) : super(key: key);

  @override
  State<MyReport> createState() => _MyReportState();
}

class _MyReportState extends State<MyReport> {
  Future<List<Map<String, dynamic>>> fetchUserCases() async {
    // Replace 'add_case' with your actual collection name
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('add_case').get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
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
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          List<Map<String, dynamic>> cases = snapshot.data ?? [];

          return Column(
            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "My Cases",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Column(
                children: cases.map((caseData) {
                  String caseName = caseData['caseName'];
                  String location = caseData['location'];

                  return _buildCaseCard(caseName, location);
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCaseCard(String caseName, String location) {
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
                builder: (context) => const MissingCaseView(),
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
