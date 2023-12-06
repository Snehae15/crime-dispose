import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/police/view%20case.dart';
import 'package:flutter/material.dart';

class PoliceViewAllCases extends StatefulWidget {
  const PoliceViewAllCases({Key? key}) : super(key: key);

  @override
  State<PoliceViewAllCases> createState() => _PoliceViewAllCasesState();
}

class _PoliceViewAllCasesState extends State<PoliceViewAllCases> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Cases"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('add_case').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> cases = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cases.length,
            itemBuilder: (context, index) {
              return _buildCaseCard(
                cases[index]['caseType'] ?? '',
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCaseCard(String caseType) {
    return Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(top: 20, right: 150),
          child: const Icon(Icons.location_on_outlined, size: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type: ${caseType ?? 'null'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Policeviewcase(
                  caseName: 'Case Name',
                  category: 'View Category',
                  imageUrl:
                      'https://s01.sgp1.digitaloceanspaces.com/large/859674-75199-axhywvjxyg-1511960362.jpg',
                  details: 'View details about the case here.',
                  location: 'View location details here.',
                ),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text("more"),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Text(
            caseType,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        shape: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
