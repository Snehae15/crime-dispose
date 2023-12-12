import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Missing_cases extends StatefulWidget {
  const Missing_cases({super.key});

  @override
  State<Missing_cases> createState() => _Missing_casesState();
}

class Case {
  final String caseName;
  final String location;

  Case({
    required this.caseName,
    required this.location,
  });
}

class _Missing_casesState extends State<Missing_cases> {
  late Future<List<Case>> missingCasesFuture;

  @override
  void initState() {
    super.initState();
    missingCasesFuture = fetchMissingCases();
  }

  Future<List<Case>> fetchMissingCases() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('add_case')
          .where('caseType', isEqualTo: 'Missing')
          .get();

      List<Case> missingCases = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Ensure the field names match the ones in Firestore document
        return Case(
          caseName: data['title'] ?? '',
          location: data['location'] ?? '',
        );
      }).toList();

      return missingCases;
    } catch (e) {
      print('Error fetching missing cases: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        title: const Text('Missing Cases'),
      ),
      backgroundColor: Colors.grey[400],
      body: Column(
        children: [
          const SizedBox(height: 8.0),
          FutureBuilder<List<Case>>(
            future: missingCasesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                print('Error in FutureBuilder: ${snapshot.error}');
                return const Center(
                  child: Text('Error loading data'),
                );
              }

              List<Case> missingCases = snapshot.data!;

              return Column(
                children: missingCases.map((missingCase) {
                  return _buildCaseCard(
                      missingCase.caseName, missingCase.location, context);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCaseCard(
      String caseName, String location, BuildContext context) {
    return Card(
      child: ListTile(
        title: const Padding(
          padding: EdgeInsets.only(top: 20, right: 150),
          child: Icon(Icons.location_on_outlined, size: 15),
        ),
        subtitle: Text(location),
        trailing: TextButton(
          onPressed: () {
            // Navigate to MissingCaseView when the "more" button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MissingCaseView(caseName: caseName),
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

class MissingCaseView extends StatelessWidget {
  final String caseName;

  const MissingCaseView({super.key, required this.caseName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Missing Case Details')),
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('add_case')
            .where('caseType', isEqualTo: 'Missing')
            .where('title', isEqualTo: caseName)
            .get()
            .then((QuerySnapshot querySnapshot) {
          return querySnapshot.docs.first;
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            print('Error in FutureBuilder: ${snapshot.error}');
            return const Center(
              child: Text('Error loading data'),
            );
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Case Name: ${data['title']}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Category: ${data['category']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8.0),
                Image.network(
                  data['imageUrl'],
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Details:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '${data['description']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Date and Time:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Date: ${data['date']}, Time: ${data['time']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Location:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Location: ${data['location']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
