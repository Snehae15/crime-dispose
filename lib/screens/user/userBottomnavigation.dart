import 'package:crime_dispose/screens/user/Profile%20view.dart';
import 'package:crime_dispose/screens/user/add%20crime.dart';
import 'package:crime_dispose/screens/user/userhome.dart';
import 'package:flutter/material.dart';

class UserBottomNavigations extends StatefulWidget {
  const UserBottomNavigations({
    super.key,
  });

  @override
  State<UserBottomNavigations> createState() => _UserBottomNavigationsState();
}

class _UserBottomNavigationsState extends State<UserBottomNavigations> {
  int currentIndex = 0;
  final pages = [
    const UserHome(),
    const AddCrime(),
    ProfilePage(),
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
