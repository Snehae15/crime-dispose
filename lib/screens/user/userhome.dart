import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/user/missing%20cases.dart';
import 'package:crime_dispose/screens/user/wanted%20cases.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  late Future<List<Map<String, dynamic>>> casesFuture;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    casesFuture = fetchCases();
  }

  Future<List<Map<String, dynamic>>> fetchCases() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot =
          await firestore.collection('add_case').get();

      List<Map<String, dynamic>> cases = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      return cases;
    } catch (e) {
      print('Error fetching cases: $e');
      throw e;
    }
  }

  List<Map<String, dynamic>> filterCases(
      List<Map<String, dynamic>> allCases, String query) {
    return allCases.where((caseData) {
      final String title = caseData['title'].toString().toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.red,
                      ),
                    ),
                    const Text(
                      "Current",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const Text(
                "CRIME DISPOSE",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (query) {
                    setState(() {
                      // Filter cases based on the search query
                      casesFuture = Future.value(filterCases([], query));
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search Crime',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Missing_cases(),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Image(
                          image: AssetImage('Asset/missing.png'),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Wanted_cases(),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Image(
                          image: AssetImage('Asset/wanted.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: casesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      print('Error in FutureBuilder: ${snapshot.error}');
                      return const Center(
                        child: Text('Error loading cases'),
                      );
                    }

                    List<Map<String, dynamic>> cases = snapshot.data!;

                    if (searchController.text.isNotEmpty) {
                      // If search query is not empty, use filtered cases
                      cases = filterCases(cases, searchController.text);
                    }

                    return Column(
                      children: cases.map((caseData) {
                        return _buildCaseCard(
                          caseData['title'] ?? '',
                          caseData['location'] ?? '',
                          caseData['type'] ?? '',
                          caseData['date'] ?? '',
                          caseData['time'] ?? '',
                          caseData['description'] ?? '',
                          caseData['imageUrl'] ?? '',
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaseCard(
    String caseName,
    String location,
    String caseType,
    Timestamp date, // Change the type to Timestamp
    String time,
    String description,
    String imageUrl,
  ) {
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
                  caseType: caseType,
                  location: location,
                  title: caseName,
                  date: date,
                  time: time,
                  description: description,
                  imageUrl: imageUrl,
                ),
              ),
            );
          },
          child: const Text("more"),
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

class CaseDetails extends StatelessWidget {
  final String caseType;
  final String location;
  final String title;
  final Timestamp date;
  final String time;
  final String description;
  final String imageUrl;

  const CaseDetails({
    Key? key,
    required this.caseType,
    required this.location,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);

  Future<void> _launchMaps(String location) async {
    final mapsUrl = 'https://maps.google.com/?q=$location';

    try {
      if (await canLaunch(mapsUrl)) {
        await launch(mapsUrl);
      } else {
        throw 'Could not launch Maps';
      }
    } catch (e) {
      print('Error launching Maps: $e');
      // Handle the error gracefully, e.g., show a dialog to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = date.toDate();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Case Type:\n $caseType',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Title:\n $title',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (imageUrl.isNotEmpty) Image.network(imageUrl),
              const SizedBox(height: 8),
              Text('Details:\n',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                maxLines: 10,
                readOnly: true,
                controller: TextEditingController(text: description),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Text('Date:\n ${dateTime.toLocal()}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8),
                  Text('Time:\n $time',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _launchMaps(location);
                    },
                    child: Text('Location:\n $location',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
