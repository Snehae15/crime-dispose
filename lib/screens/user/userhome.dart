import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/user/missing%20cases.dart';
import 'package:crime_dispose/screens/user/wanted%20cases.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:url_launcher/url_launcher.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  late Future<List<Map<String, dynamic>>> casesFuture;
  TextEditingController searchController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    casesFuture = fetchCases();
  }

  Future<void> _selectLocation(BuildContext context) async {
    try {
      loc.Location location = loc.Location();
      loc.LocationData? currentLocation = await location.getLocation();

      if (currentLocation != null) {
        double latitude = currentLocation.latitude!;
        double longitude = currentLocation.longitude!;

        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);

        if (placemarks.isNotEmpty) {
          Placemark firstPlacemark = placemarks.first;
          String locationName =
              "${firstPlacemark.subLocality}, ${firstPlacemark.locality}";

          setState(() {
            locationController.text = locationName;
          });
        } else {
          setState(() {
            locationController.text = 'Location not found';
          });
        }
      } else {
        // Handle the case where location is null
      }
    } catch (e) {
      print('Error getting location: $e');
    }
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
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchCasesByTitle(String title) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('add_case')
          .where('title', isEqualTo: title.toUpperCase())
          .get();

      List<Map<String, dynamic>> cases = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      return cases;
    } catch (e) {
      print('Error fetching cases: $e');
      rethrow;
    }
  }

  List<Map<String, dynamic>> filterCases(
      List<Map<String, dynamic>> allCases, String query) {
    return allCases.where((caseData) {
      final String title = caseData['title'].toString().toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();
  }

  Widget _buildCaseCard(
    String caseName,
    String location,
    String caseType,
    Timestamp date,
    String time,
    String description,
    String imageUrl,
  ) {
    return Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Text(
            caseName,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        subtitle: SingleChildScrollView(
          scrollDirection:
              Axis.horizontal, // or Axis.vertical based on your content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.location_on_outlined, size: 15),
                  ),
                  Text(location),
                ],
              ),
              // Add more information if needed
            ],
          ),
        ),
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
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
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
                      onTap: () {
                        _selectLocation(context);
                      },
                      child: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.red,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectLocation(context);
                      },
                      child: Text(
                        locationController.text,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
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
                      casesFuture = fetchCasesByTitle(query);
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
    super.key,
    required this.caseType,
    required this.location,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    required this.imageUrl,
  });

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
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Title:\n $title',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (imageUrl.isNotEmpty) Image.network(imageUrl),
              const SizedBox(height: 8),
              const Text('Details:\n',
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
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8),
                  Text('Time:\n $time',
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              // Include this part to display the caseType
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.category),
                  const SizedBox(width: 8),
                  Text('Case Type:\n $caseType',
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
