import 'package:crime_dispose/screens/user/case%20name.dart';
import 'package:crime_dispose/screens/user/missing%20cases.dart';
import 'package:crime_dispose/screens/user/wanted%20cases.dart';
import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.red,
                    ),
                  ),
                  const Text(
                    "Current",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ],
              ),
            ),
            const Text(
              "CRIME DISPOSE",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to the next page when the Container is clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Missing_cases(),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Image(
                        image: AssetImage('Asset/missing.png'),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Wanted_cases(),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Image(
                        image: AssetImage('Asset/wanted.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildCaseCard("Case 1 Name", "Location 1"),
                  _buildCaseCard("Case 2 Name", "Location 2"),
                  _buildCaseCard("Case 3 Name", "Location 3"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseCard(String caseName, String location) {
    return Card(
      child: ListTile(
        title: const Padding(
          padding: EdgeInsets.only(top: 20, right: 150),
          child: Icon(Icons.location_on_outlined, size: 15),
        ),
        subtitle: Text(location),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WantedCaseView(),
              ),
            );
          },
          child: const Text("more"),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Text(
            caseName,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
