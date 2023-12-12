import 'package:crime_dispose/screens/police/add%20case.dart';
import 'package:crime_dispose/screens/police/all%20case%20view.dart';
import 'package:crime_dispose/screens/police/police%20view%20profile.dart';
import 'package:flutter/material.dart';

class PoliceBottomNaviagtion extends StatefulWidget {
  const PoliceBottomNaviagtion({
    super.key,
  });

  @override
  State<PoliceBottomNaviagtion> createState() => _PoliceBottomNaviagtionState();
}

class _PoliceBottomNaviagtionState extends State<PoliceBottomNaviagtion> {
  int currentIndex = 0;
  final pages = [
    const PoliceViewAllCases(),
    const PoliceAddCase(),
    const ViewProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[400],
        shape: const CircularNotchedRectangle(),
        notchMargin: 50.0, // Adjust the notch margin as needed
        child: SizedBox(
          height: 20.0, // Increase the height of the BottomAppBar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(Icons.home, 0),
              _buildIconButton(Icons.add, 1),
              _buildIconButton(Icons.perm_identity_sharp, 2),
            ],
          ),
        ),
      ),
    );
  }

  IconButton _buildIconButton(IconData icon, int index) {
    return IconButton(
      icon: Icon(icon),
      color: currentIndex == index ? Colors.black : Colors.black,
      onPressed: () {
        _changePage(index);
      },
    );
  }

  void _changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
