import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_dispose/screens/user/edit%20user%20profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewStudentProfile extends StatefulWidget {
  const ViewStudentProfile({super.key});

  @override
  State<ViewStudentProfile> createState() => _ViewStudentProfileState();
}

class _ViewStudentProfileState extends State<ViewStudentProfile> {
  late User loggedInUser;
  String? firstName;
  String? email;
  String? addressLine1;
  String? addressLine2;
  String? phoneNumber;
  String? city;
  String? state;
  String? district;
  String? dob;
  String? documentDetails;

  @override
  void initState() {
    super.initState();
    // Get the currently logged-in user
    loggedInUser = FirebaseAuth.instance.currentUser!;
    print("User ID: ${loggedInUser.uid}");
    // Set initial values or leave them as null
    firstName = null;
    email = null;
    addressLine1 = null;
    addressLine2 = null;
    phoneNumber = null;
    city = null;
    state = null;
    district = null;
    dob = null;
    documentDetails = null;

    // Fetch user details from Firestore
    fetchUserDetails();
    }

  // Function to fetch user details from Firestore
  Future<void> fetchUserDetails() async {
    try {
      // Access Firestore collection 'users' and document with UID
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(loggedInUser.uid)
          .get();

      // Print the entire snapshot for debugging
      print("Snapshot data: ${snapshot.data()}");

      // Check if the document exists
      if (snapshot.exists) {
        // Set user details from Firestore
        setState(() {
          firstName = snapshot.get('firstName') ?? 'N/A';
          var lastName = snapshot.get('lastName') ?? 'N/A';
          email = snapshot.get('email') ?? 'N/A';
          addressLine1 = snapshot.get('addressLine1') ?? 'N/A';
          addressLine2 = snapshot.get('addressLine2') ?? 'N/A';
          phoneNumber = snapshot.get('phoneNumber') ?? 'N/A';
          city = snapshot.get('city') ?? 'N/A';
          state = snapshot.get('state') ?? 'N/A';
          district = snapshot.get('district') ?? 'N/A';
          dob = snapshot.get('dob') ?? 'N/A';
          documentDetails = snapshot.get('documentDetails') ?? 'N/A';
        });

        print("Fetched Data: $firstName, $email, ...");
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  // Function to handle the navigation to the edit profile page
  void _navigateToEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EditUserProfile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditProfile,
          ),
        ],
      ),
      backgroundColor: Colors.grey[400],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: fetchUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildDetailField("First Name", firstName),
                        buildDetailField("Email", email),
                        buildDetailField("Address Line 1", addressLine1),
                        buildDetailField("Address Line 2", addressLine2),
                        buildDetailField("Phone Number", phoneNumber),
                        buildDetailField("City", city),
                        buildDetailField("State", state),
                        buildDetailField("District", district),
                        buildDetailField("DOB", dob),
                        buildDetailField("Document Details", documentDetails),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  // Function to build each detail field
  Widget buildDetailField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: value ?? 'N/A',
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
