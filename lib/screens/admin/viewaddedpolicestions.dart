import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPoliceStations extends StatefulWidget {
  const ViewPoliceStations({Key? key}) : super(key: key);

  @override
  State<ViewPoliceStations> createState() => _ViewPoliceStationsState();
}

class _ViewPoliceStationsState extends State<ViewPoliceStations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Police Stations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PoliceStationList(),
      ),
    );
  }
}

class PoliceStationList extends StatelessWidget {
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

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            return PoliceStationCard(
              policeId: data['policeId'],
              password: data['password'],
              policeStationName: data['policeStationName'],
              policeStationAddress: data['policeStationAddress'],
              policePhoneNumber: data['policePhoneNumber'],
            );
          }).toList(),
        );
      },
    );
  }
}

class PoliceStationCard extends StatelessWidget {
  final String policeId;
  final String password;
  final String policeStationName;
  final String policeStationAddress;
  final String policePhoneNumber;

  const PoliceStationCard({
    required this.policeId,
    required this.password,
    required this.policeStationName,
    required this.policeStationAddress,
    required this.policePhoneNumber,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: Colors.blue),
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
            Row(
              children: [
                const Icon(Icons.location_city, color: Colors.green),
                Text(' Station Address: $policeStationAddress'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.teal),
                Text(' Phone Number: $policePhoneNumber'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
