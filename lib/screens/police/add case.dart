import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/police/all%20case%20view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;

class PoliceAddCase extends StatefulWidget {
  const PoliceAddCase({super.key});

  @override
  _PoliceAddCaseState createState() => _PoliceAddCaseState();
}

class _PoliceAddCaseState extends State<PoliceAddCase> {
  File? image;
  String selectedCaseType = 'Theft';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();

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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> _selectLocation(BuildContext context) async {
    try {
      loc.Location location = loc.Location();
      loc.LocationData currentLocation = await location.getLocation();

      double latitude = currentLocation.latitude!;
      double longitude = currentLocation.longitude!;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark firstPlacemark = placemarks.first;
        String locationName =
            "${firstPlacemark.subLocality}, ${firstPlacemark.locality}";

        setState(() {
          locationController.text = locationName;
        });
      } else {
        setState(() {
          locationController.text = 'Location not found';
        });
      }
    } catch (e) {
      print('Error getting location: $e');
      Fluttertoast.showToast(
        msg: 'Error getting location. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
          'time':
              '${selectedTime.hour}:${selectedTime.minute}', // Convert TimeOfDay to string
          'description': descriptionController.text,
          'title': titleController.text,
          'location': locationController.text,
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
          MaterialPageRoute(builder: (context) => const PoliceViewAllCases()),
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
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Crime Title',
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
            Row(
              children: [
                const Text(
                  'Time:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: const Icon(Icons.access_time),
                ),
                const SizedBox(width: 8.0),
                Text(
                  selectedTime.format(context),
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectLocation(context),
              child: const Row(
                children: [
                  Icon(Icons.location_on), // Location icon
                  SizedBox(width: 8.0),
                  Text('Select Location'),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Crime Location',
                border: OutlineInputBorder(),
              ),
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
