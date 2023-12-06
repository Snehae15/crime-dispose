import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddCrime extends StatefulWidget {
  const AddCrime({Key? key}) : super(key: key);

  @override
  _AddCrimeState createState() => _AddCrimeState();
}

class _AddCrimeState extends State<AddCrime> {
  TextEditingController crimeTitleController = TextEditingController();
  TextEditingController crimeLocationController = TextEditingController();
  TextEditingController complaintController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();
  String crimeType = "Theft";
  XFile? crimeImage;
  String currentLocation = "Unknown";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDateTime) {
      setState(() {
        selectedDateTime = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (pickedTime != null) {
      setState(() {
        selectedDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  Future<void> _uploadCrimeReport() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('add_case').add({
        'crimeType': crimeType,
        'crimeTitle': crimeTitleController.text,
        'dateTime': selectedDateTime,
        'crimeLocation': crimeLocationController.text,
        'complaint': complaintController.text,
        'imageURL': crimeImage?.path,
        // Add other fields as needed
      });

      // Reset form after successful upload
      setState(() {
        crimeTitleController.clear();
        crimeLocationController.clear();
        complaintController.clear();
        selectedDateTime = DateTime.now();
        crimeType = "Theft";
        crimeImage = null;
        currentLocation = "Unknown";
      });

      // Optionally, show a success message or navigate to another screen
    } catch (error) {
      // Handle the error, e.g., show an error message
      print('Error uploading crime report: $error');
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
                value: crimeType,
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
                    crimeType = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Select Crime Type",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: crimeTitleController,
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
                      "Selected Date and Time: ${DateFormat.yMd().add_jm().format(selectedDateTime)}",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: crimeLocationController,
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
                  Expanded(
                    child: Text(
                      "Picked Location: $currentLocation",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: complaintController,
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
                          crimeImage = pickedImage;
                        });
                      },
                      icon: const Icon(Icons.image),
                      label: const Text("Upload Image"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text("Image: ${crimeImage?.name ?? 'None'}"),
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
