import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/user/view%20student%20Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({super.key});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  late User loggedInUser;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController documentDetailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get the currently logged-in user
    loggedInUser = FirebaseAuth.instance.currentUser!;
    print("User ID: ${loggedInUser.uid}");
    // Fetch user details from Firestore
    fetchUserDetails();
    }

  Future<void> fetchUserDetails() async {
    try {
      // Access Firestore collection 'users' and document with UID
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(loggedInUser.uid)
          .get();

      // Check if the document exists
      if (snapshot.exists) {
        // Set user details from Firestore to TextEditingController
        firstNameController.text = snapshot.get('firstName') ?? '';
        emailController.text = snapshot.get('email') ?? '';
        addressLine1Controller.text = snapshot.get('addressLine1') ?? '';
        addressLine2Controller.text = snapshot.get('addressLine2') ?? '';
        phoneNumberController.text = snapshot.get('phoneNumber') ?? '';
        cityController.text = snapshot.get('city') ?? '';
        stateController.text = snapshot.get('state') ?? '';
        districtController.text = snapshot.get('district') ?? '';
        dobController.text = snapshot.get('dob') ?? '';
        documentDetailsController.text = snapshot.get('documentDetails') ?? '';
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dobController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> saveChanges() async {
    try {
      // Access Firestore collection 'users' and document with UID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUser.uid)
          .update({
        'firstName': firstNameController.text,
        'email': emailController.text,
        'addressLine1': addressLine1Controller.text,
        'addressLine2': addressLine2Controller.text,
        'phoneNumber': phoneNumberController.text,
        'city': cityController.text,
        'state': stateController.text,
        'district': districtController.text,
        'dob': dobController.text,
        'documentDetails': documentDetailsController.text,
      });

      // Navigate back to the profile view after saving changes
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const ViewStudentProfile();
          },
        ),
      );
    } catch (e) {
      print("Error saving changes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
      ),
      backgroundColor: Colors.grey[400],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildTextFormField("First Name", firstNameController),
                  buildTextFormField("Email", emailController),
                  buildTextFormField("AddressLine1", addressLine1Controller),
                  buildTextFormField("AddressLine2", addressLine2Controller),
                  buildTextFormField("Phone number", phoneNumberController),
                  buildTextFormField("City", cityController),
                  buildTextFormField("State", stateController),
                  buildTextFormField("District", districtController),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: buildTextFormField("Dob", dobController),
                  ),
                  buildTextFormField(
                      "Document Details", documentDetailsController),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
