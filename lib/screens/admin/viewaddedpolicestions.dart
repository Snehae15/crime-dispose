import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPoliceStations extends StatelessWidget {
  const ViewPoliceStations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Police Stations'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: PoliceStationList(),
      ),
    );
  }
}

class PoliceStationList extends StatelessWidget {
  const PoliceStationList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('add_police').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Error loading data');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final policeStations = snapshot.data!.docs.map(
          (DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            return PoliceStation(
              policeId: data['policeId'],
              password: data['password'],
              policeStationName: data['policeStationName'],
              policeStationAddress: data['policeStationAddress'],
              policePhoneNumber: data['policePhoneNumber'],
            );
          },
        ).toList();

        return ListView(
          children: policeStations,
        );
      },
    );
  }
}

class PoliceStation extends StatelessWidget {
  final String policeId;
  final String password;
  final String policeStationName;
  final String policeStationAddress;
  final String policePhoneNumber;

  const PoliceStation({
    required this.policeId,
    required this.password,
    required this.policeStationName,
    required this.policeStationAddress,
    required this.policePhoneNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Split the address into lines
    List<String> addressLines = policeStationAddress.split('\n');

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text('Police ID: $policeId'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lock, color: Colors.grey),
                Text(' Password: $password'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.business, color: Colors.blue),
                Text(' Station Name: $policeStationName'),
              ],
            ),
            // Display address lines
            for (String addressLine in addressLines)
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.red),
                  Text(' $addressLine'),
                ],
              ),
            InkWell(
              onTap: () => _makePhoneCall(policePhoneNumber),
              child: Row(
                children: [
                  const Icon(Icons.phone, color: Colors.teal),
                  Text(
                    'Phone Number: $policePhoneNumber',
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
