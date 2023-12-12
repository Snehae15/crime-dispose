import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminAddPolice extends StatefulWidget {
  const AdminAddPolice({super.key});

  @override
  State<AdminAddPolice> createState() => _AdminAddPoliceState();
}

class _AdminAddPoliceState extends State<AdminAddPolice> {
  final TextEditingController _policeIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _policeStationNameController =
      TextEditingController();
  final TextEditingController _policeStationAddressController =
      TextEditingController();
  final TextEditingController _policePhoneNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'ADD POLICE STATION',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _policeIdController,
              label: 'Police ID',
              hint: 'Enter ID',
              icon: Icons.person,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _policeStationNameController,
              label: 'Police Station Name',
              hint: 'Enter Station Name',
              icon: Icons.person,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _policeStationAddressController,
              label: 'Police Station Address',
              hint: 'Enter Station Address',
              icon: Icons.location_on,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              keyboardType: TextInputType.number,
              controller: _policePhoneNumberController,
              label: 'Police Station Phone Number',
              hint: 'Enter Phone Number',
              icon: Icons.phone,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Enter password',
              icon: Icons.lock,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addPoliceToFirestore();
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Add Police'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Future<void> addPoliceToFirestore() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      String policeId = _policeIdController.text.trim();
      String password = _passwordController.text.trim();
      String policeStationName = _policeStationNameController.text.trim();
      String policeStationAddress = _policeStationAddressController.text.trim();
      String policePhoneNumber = _policePhoneNumberController.text.trim();

      // Check if any field is empty
      if (policeId.isEmpty ||
          password.isEmpty ||
          policeStationName.isEmpty ||
          policeStationAddress.isEmpty ||
          policePhoneNumber.isEmpty) {
        showToast('Please fill in all fields', false);
        return;
      }

      // Use set with merge: true to update existing document or create a new one
      await firestore.collection('add_police').doc(policeId).set(
        {
          'policeId': policeId,
          'password': password,
          'policeStationName': policeStationName,
          'policeStationAddress': policeStationAddress,
          'policePhoneNumber': policePhoneNumber,
        },
        SetOptions(
            merge: true), // Merge with existing data if the document exists
      );

      showToast('Police station added successfully', true);
    } catch (e) {
      print('Error adding police station: $e');
      handleFirestoreError(e);
    }
  }

  void handleFirestoreError(dynamic error) {
    String errorMessage = 'Failed to add police station';

    if (error is FirebaseException) {
      if (error.code == 'unavailable') {
        errorMessage = 'Firebase services are currently unavailable';
      } else if (error.code == 'permission-denied') {
        errorMessage = 'Permission denied to add police station';
      }
    }

    showToast(errorMessage, false);
  }

  void showToast(String message, bool isSuccess) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    _policeIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
