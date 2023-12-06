import 'package:flutter/material.dart';

class About_page extends StatefulWidget {
  const About_page({super.key});

  @override
  State<About_page> createState() => _About_pageState();
}

class _About_pageState extends State<About_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        title: const Text('About CRIME DISPOSE'),
      ),
      backgroundColor: Colors.grey[400],
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CRIME DISPOSE',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Recent researchers have identified mobile handheld devices as a possible tool for effective crime detection and reporting. Technological advancements have led to the invention of extremely powerful mobile handheld devices and have brought about large and high-speed data transfer capabilities through mobile communication networks. Functions of mobile devices have evolved from merely making calls to performing complex computations over the past three decades. The high computational power of smartphones, tablets, and PDAs accounts for their high demand and usage by the general public. Smartphone shipments worldwide reached 485 million in 2011, increased to about 655 million in 2012, and expected to rise over one billion smartphones by 2016. Another key factor making mobile phone technology a viable medium for fighting crime is the advancement of cellular network technologies. The introduction of 3G/4G/5G cellular network technologies by most mobile network operators has improved the communication demands for mobile users. With these two factors in place, development of dedicated mobile platforms for detecting and reporting criminal activities is a great possibility. It is a platform that can be implemented as a security assistant of the police for crime control purpose.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
