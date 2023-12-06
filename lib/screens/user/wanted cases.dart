import 'package:crime_dispose/screens/user/case%20name.dart';
import 'package:flutter/material.dart';

class Wanted_cases extends StatefulWidget {
  const Wanted_cases({Key? key}) : super(key: key);

  @override
  State<Wanted_cases> createState() => _Wanted_casesState();
}

class _Wanted_casesState extends State<Wanted_cases> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[400],
      body: Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Wanted Cases",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _buildCaseCard("Case 1", "2A madhurika Apt"),
                _buildCaseCard("Case 2", "2A madhurika Apt"),
                _buildCaseCard("Case 3", "2A madhurika Apt"),
                _buildCaseCard("Case 4", "2A madhurika Apt"),
                _buildCaseCard("Case 5", "2A madhurika Apt"),
                _buildCaseCard("Case 6", "2A madhurika Apt"),
              ],
            ),
          ),
        ],
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
            // Navigate to CasePage when the "more" button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WantedCaseView(),
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
