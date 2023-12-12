import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PoliceViewCaseDetails extends StatelessWidget {
  final String caseType;
  final String location;
  final String title;
  final Timestamp date;
  final String time;
  final String description;
  final String imageUrl;

  const PoliceViewCaseDetails({
    super.key,
    required this.caseType,
    required this.location,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = date.toDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Case Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Case Type: $caseType',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Title: $title',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (imageUrl.isNotEmpty) Image.network(imageUrl),
              const SizedBox(height: 8),
              const Text('Details:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                maxLines: null,
                readOnly: true,
                controller: TextEditingController(text: description),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Text('Date: ${dateTime.toLocal()}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8),
                  Text('Time: $time'),
                ],
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  _launchMaps(location);
                },
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(width: 8),
                    Text('Location: $location',
                        style: const TextStyle(decoration: TextDecoration.underline)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchMaps(String location) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class PoliceViewAllCases extends StatefulWidget {
  const PoliceViewAllCases({super.key});

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
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('add_case').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<DocumentSnapshot> cases = snapshot.data!.docs;

            return Column(
              children: cases
                  .map(
                    (caseDocument) => _buildCaseCard(caseDocument),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCaseCard(DocumentSnapshot caseDocument) {
    String caseType = caseDocument['caseType'] ?? '';
    String location = caseDocument['location'] ?? '';
    String title = caseDocument['title'] ?? '';
    Timestamp date = caseDocument['date'] ?? Timestamp.now();
    String time = caseDocument['time'] ?? '';
    String description = caseDocument['description'] ?? '';
    String imageUrl = caseDocument['imageUrl'] ?? '';

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                caseType,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.location_on),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Location: $location',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            _viewCaseDetails(
              caseType,
              location,
              title,
              date,
              time,
              description,
              imageUrl,
            );
          },
          child: const Text("More"),
        ),
      ),
    );
  }

  void _viewCaseDetails(
    String caseType,
    String location,
    String title,
    Timestamp date,
    String time,
    String description,
    String imageUrl,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PoliceViewCaseDetails(
          caseType: caseType,
          location: location,
          title: title,
          date: date,
          time: time,
          description: description,
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}
