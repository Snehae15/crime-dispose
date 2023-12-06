import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewProfile extends StatefulWidget {
  final String loggedInPoliceId;

  const ViewProfile({
    Key? key,
    required this.loggedInPoliceId,
  }) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class PoliceStation {
  final String policeStationName;
  final String policeStationAddress;
  final String policePhoneNumber;

  PoliceStation({
    required this.policeStationName,
    required this.policeStationAddress,
    required this.policePhoneNumber,
  });
}

class _ViewProfileState extends State<ViewProfile> {
  late Future<PoliceStation> policeStationFuture;

  @override
  void initState() {
    super.initState();
    policeStationFuture = fetchPoliceStationDetails();
  }

  Future<PoliceStation> fetchPoliceStationDetails() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('add_police')
          .where('policeId', isEqualTo: widget.loggedInPoliceId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        return PoliceStation(
          policeStationName: data['policeStationName'] ?? '',
          policeStationAddress: data['policeStationAddress'] ?? '',
          policePhoneNumber: data['policePhoneNumber'] ?? '',
        );
      }

      // If no data is found, return an empty PoliceStation object
      return PoliceStation(
        policeStationName: '',
        policeStationAddress: '',
        policePhoneNumber: '',
      );
    } catch (e) {
      print('Error fetching police station details: $e');
      // Rethrow the exception to propagate it to the FutureBuilder
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Police Station Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<PoliceStation>(
          future: policeStationFuture,
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

            PoliceStation policeStation = snapshot.data!;

            return Card(
              elevation: 5.0,
              child: ListTile(
                title: Text(
                  policeStation.policeStationName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.blue),
                        const SizedBox(width: 8.0),
                        Text(policeStation.policeStationAddress),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.green),
                        const SizedBox(width: 8.0),
                        Text(policeStation.policePhoneNumber),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
