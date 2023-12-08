import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NearPoliceStationPage extends StatelessWidget {
  const NearPoliceStationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Police Station Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<PoliceStation>>(
          future: fetchPoliceStations(),
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

            List<PoliceStation> policeStations = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: policeStations.length,
                    itemBuilder: (context, index) {
                      PoliceStation policeStation = policeStations[index];
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
                                  const Icon(Icons.location_on,
                                      color: Colors.blue),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<PoliceStation>> fetchPoliceStations() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot =
          await firestore.collection('add_police').get();

      List<PoliceStation> policeStations = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return PoliceStation(
          policeStationName: data['policeStationName'] ?? '',
          policeStationAddress: data['policeStationAddress'] ?? '',
          policePhoneNumber: data['policePhoneNumber'] ?? '',
        );
      }).toList();

      return policeStations;
    } catch (e) {
      print('Error fetching police stations: $e');
      throw e;
    }
  }
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
