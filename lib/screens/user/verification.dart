import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/user/userBottomnavigation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  DateTime? selectedDate;
  String? selectedDocumentType;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectDocumentType(String? value) async {
    setState(() {
      selectedDocumentType = value;
    });
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        final bytes = result.files.single.bytes;

        if (bytes != null) {
          // Upload file to Firebase Storage
          final user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            final storageRef = firebase_storage.FirebaseStorage.instance
                .ref()
                .child('verification_files')
                .child(user.uid)
                .child('document_file');

            final task = storageRef.putData(bytes);

            // Wait for the upload to complete
            await task.whenComplete(() {});

            // Get the download URL
            final downloadURL = await storageRef.getDownloadURL();

            // Upload verification details to Firestore
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({
              'dateOfBirth': selectedDate,
              'documentType': selectedDocumentType,
              'documentDownloadURL': downloadURL,
              'verificationStatus': 'Pending',
            });
          }
        }
      } else {
        // User canceled the file picking
        // Handle accordingly or provide feedback
      }
    } catch (e) {
      // Handle file picking error
      print('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: [
                Center(
                  child: Text(
                    "Verification",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              onTap: () => _selectDate(context),
              leading: Text(
                selectedDate != null
                    ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
                    : "Select Date of Birth",
              ),
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              leading: const Text("Document type"),
              trailing: DropdownButton<String>(
                value: selectedDocumentType,
                items: [
                  "Aadhar Card",
                  "Driving License",
                  "Voter ID",
                  "Passport",
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => _selectDocumentType(value),
              ),
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              onTap: () => _pickFile(),
              leading: const Text(
                "Upload Document",
              ),
              trailing: const Icon(Icons.file_upload),
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: ElevatedButton(
              onPressed: () async {
                // Upload verification details to Firestore
                await _pickFile();

                // Navigate to the next screen
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const UserBottomNavigations();
                  },
                ));
              },
              child: const Text("Done"),
            ),
          )
        ],
      ),
    );
  }
}
