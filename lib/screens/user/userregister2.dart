import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/user/verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User_register2 extends StatefulWidget {
  const User_register2({
    super.key,
  });

  @override
  State<User_register2> createState() => _User_register2State();
}

class _User_register2State extends State<User_register2> {
  String selectedDistrict = "Select";
  List<String> keralaDistricts = [
    "Select",
    "Alappuzha",
    "Ernakulam",
    "Idukki",
    "Kannur",
    "Kasaragod",
    "Kollam",
    "Kottayam",
    "Kozhikode",
    "Malappuram",
    "Palakkad",
    "Pathanamthitta",
    "Thiruvananthapuram",
    "Thrissur",
    "Wayanad"
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _stateController = TextEditingController(
    text: "Kerala",
  );
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Your Address",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _stateController,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "State",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedDistrict,
                    items: keralaDistricts.map((String district) {
                      return DropdownMenuItem<String>(
                        value: district,
                        child: Text(district),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDistrict = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == "Select") {
                        return 'Please select a district';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "District",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _addressLine1Controller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address line 1';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Address line 1",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _addressLine2Controller,
                    validator: (value) {
                      // You can customize the validation logic as needed
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Address line 2",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _postcodeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your postcode';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Postcode",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _cityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your city';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "City",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Validation passed, add user address to Firestore
                        await _addUserAddressToFirestore();

                        // Navigate to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const Verification();
                            },
                          ),
                        );
                      }
                    },
                    child: const Text("Next"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addUserAddressToFirestore() async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Add user address to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'state': _stateController.text,
          'district': selectedDistrict,
          'addressLine1': _addressLine1Controller.text,
          'addressLine2': _addressLine2Controller.text,
          'postcode': _postcodeController.text,
          'city': _cityController.text,
        });
      }
    } catch (e) {
      print('Error adding user address to Firebase: $e');
    }
  }
}
