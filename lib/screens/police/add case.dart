import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/police/all%20case%20view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class PoliceAddCase extends StatefulWidget {
  @override
  _PoliceAddCaseState createState() => _PoliceAddCaseState();
}

class _PoliceAddCaseState extends State<PoliceAddCase> {
  File? image;
  String selectedCaseType = 'Theft';
  DateTime selectedDate = DateTime.now();
  TextEditingController descriptionController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage == null) return;

      setState(() {
        image = File(pickedImage.path);
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _uploadCase() async {
    try {
      print('Uploading case...');

      // Upload image to Firebase Storage
      if (image != null) {
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference =
            FirebaseStorage.instance.ref().child('case_images/$imageName');
        await storageReference.putFile(image!);

        // Get the download URL
        String imageUrl = await storageReference.getDownloadURL();
        print('Image uploaded. URL: $imageUrl');

        // Save case details to Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentReference caseReference =
            await firestore.collection('add_case').add({
          'caseType': selectedCaseType,
          'date': selectedDate,
          'description': descriptionController.text,
          'imageUrl': imageUrl,
        });

        print('Case details uploaded to Firestore.');

        // Show selected image name and toast message
        Fluttertoast.showToast(
          msg: 'Case added successfully!\nImage Name: $imageName',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Navigate to PoliceViewAllCases
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PoliceViewAllCases()),
        );
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error uploading case: $e');
      Fluttertoast.showToast(
        msg: 'Error uploading case. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Case'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: const Text(
                'Select an image and enter case details:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Pick Image from Camera'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Pick Image from Gallery'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Case Details:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              value: selectedCaseType,
              items: [
                "Missing",
                "wanted",
                "Theft",
                "Assault",
                "Vandalism",
                "Burglary",
                "Fraud",
                "Drug Offenses",
                "Cybercrime",
                "Domestic Violence",
                "Sexual Assault",
                "White-Collar Crime",
                "Homicide",
                "Kidnapping",
                "Child Abuse",
                "Arson",
                "Trespassing",
                "Hate Crimes",
                "Public Order Offenses",
                "Driving Under the Influence (DUI)",
                "Environmental Crimes",
                "Animal Cruelty",
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedCaseType = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Select Crime Type",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text(
                  'Date:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: const Icon(Icons.date_range),
                ),
                const SizedBox(width: 8.0),
                Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Case Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadCase,
              child: const Text('Upload Case'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Police App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PoliceAddCase(),
    );
  }
}