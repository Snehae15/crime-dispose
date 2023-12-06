import 'package:flutter/material.dart';

class NearPoliceStationPage extends StatelessWidget {
  const NearPoliceStationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Police Stations"),
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Stations",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text("Police Station 1"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Location 1"),
                    Text("Telephone Number 1"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text("Police Station 2"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Location 2"),
                    Text("Telephone Number 2"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text("Police Station 3"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Location 3"),
                    Text("Telephone Number 3"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
