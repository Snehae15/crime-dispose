import 'package:crime_dispose/screens/user/userregister2.dart';
import 'package:flutter/material.dart';

class Otp_verification1 extends StatefulWidget {
  const Otp_verification1({super.key});

  @override
  State<Otp_verification1> createState() => _Otp_verification1State();
}

class _Otp_verification1State extends State<Otp_verification1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 310),
            child: CircleAvatar(
                backgroundColor: Colors.lightBlue,
                radius: 15,
                child: Icon(Icons.arrow_back_ios_new)),
          ),
          Column(
            children: [
              Stack(children: [
                Container(
                  height: 390,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(color: Colors.grey),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 50,
                            ),
                            child: Text("OTP Verification",
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 70, right: 50, top: 50),
                          child: Text(
                              "OTP has send to  your  mobile number.Please enter it below",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 310),
                  child: Container(
                    height: 417,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 85,
                              width: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey),
                            ),
                            Container(
                              height: 85,
                              width: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey),
                            ),
                            Container(
                              height: 85,
                              width: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey),
                            ),
                            Container(
                              height: 85,
                              width: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Dont recieve an otp ?",
                            style: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "resend otp",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const User_register2();
                              },
                            ));
                          },
                          child: const Text("Next"),
                        ),
                      )
                    ]),
                  ),
                )
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
