import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PoliceAddProfile extends StatefulWidget {
  const PoliceAddProfile({
    super.key,
  });

  @override
  State<PoliceAddProfile> createState() => _PoliceAddProfileState();
}

class _PoliceAddProfileState extends State<PoliceAddProfile> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;

  void _addPoliceProfile() {
    String name = _nameController.text;
    String address = _addressController.text;
    String phoneNumber = _phoneNumberController.text;

    // Add data to Firebase collection
    _firestore.collection('add_police').add({
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
    });

    // You can add further logic like showing a success message or navigating back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD POLICE PROFILE"),
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration:
                  const InputDecoration(labelText: 'Police Station Name'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _addPoliceProfile,
              child: const Text('Add Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
