import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/user/userhome.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;

class AddCrime extends StatefulWidget {
  const AddCrime({super.key});

  @override
  _AddCrimeState createState() => _AddCrimeState();
}

class _AddCrimeState extends State<AddCrime> {
  File? image;
  String selectedCaseType = 'Theft';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool isLoading = false;

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

  Future<void> _uploadCrimeReport() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (image != null) {
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference =
            FirebaseStorage.instance.ref().child('crime_images/$imageName');
        await storageReference.putFile(image!);

        String imageUrl = await storageReference.getDownloadURL();

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('add_case').add({
          'caseType': selectedCaseType,
          'date': selectedDate,
          'time': '${selectedTime.hour}:${selectedTime.minute}',
          'description': descriptionController.text,
          'title': titleController.text,
          'location': locationController.text,
          'imageUrl': imageUrl,
        });

        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(
          msg: 'Crime report added successfully!\nImage Name: $imageName',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserHome()),
        );
      } else {
        print('No image selected.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error uploading crime report: $e');
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
        msg: 'Error uploading crime report. Please try again.',
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
        title: const Text("Report Crime"),
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCaseType,
                items: [
                  "Missing",
                  "Wanted",
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
              const SizedBox(height: 12),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Crime Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: const Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 8),
                          Text("Select Date"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: const Row(
                        children: [
                          Icon(Icons.access_time),
                          SizedBox(width: 8),
                          Text("Select Time"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Selected Date and Time: ${DateFormat.yMd().add_jm().format(selectedDate)}",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Crime Location",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(width: 8),
                          Text("Select Current Location"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _selectLocation(context),
                    child: const Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 8.0),
                        Text('Select Location'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Complaint",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final imagePicker = ImagePicker();
                        final pickedImage = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                        );

                        setState(() {
                          image = pickedImage != null
                              ? File(pickedImage.path)
                              : null;
                        });
                      },
                      icon: const Icon(Icons.image),
                      label: const Text("Upload Image"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                      "Image: ${image != null ? image!.path.split('/').last : 'None'}"),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _uploadCrimeReport();
                },
                child: const Text("Submit Crime"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
