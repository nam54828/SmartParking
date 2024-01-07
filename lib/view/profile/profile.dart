import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_parking/Login/login.dart';
import 'package:smart_parking/bottomBar/Home/Select/myCar/registeredLicensePlate.dart';
import 'package:smart_parking/bottomBar/profile/terms.dart';

import '../../main.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "PROFILE",
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            )),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                          radius: 35,
                          backgroundColor: Color(0xffFDCF09),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                "https://s3.o7planning.com/images/boy-128.png"),
                          ))
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: StreamBuilder(
                              stream: FirebaseDatabase.instance
                                  .ref()
                                  .child('users')
                                  .child(currentUser.currentUser!.uid)
                                  .child('user')
                                  .onValue,
                              builder: (BuildContext context,
                                  AsyncSnapshot<DatabaseEvent> snapshot) {
                                if (snapshot.hasData) {
                                  final fullname = snapshot.data?.snapshot.value
                                          ?.toString() ??
                                      '';
                                  return Text(
                                    fullname,
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Satoshi-Bold',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),

                                  );
                                } else {
                                  return Expanded(
                                    child: Shimmer(child: Container(
                                      width: 100,
                                      height: 50,
                                    ), gradient: LinearGradient(colors: [
                                      Color(0x8388888A)
                                    ])),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            child: StreamBuilder(
                              stream: FirebaseDatabase.instance
                                  .ref()
                                  .child("users")
                                  .child(currentUser.currentUser!.uid)
                                  .child("email")
                                  .onValue,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final email = snapshot.data?.snapshot.value
                                          .toString() ??
                                      '';
                                  return Center(
                                    child: Text(
                                      email,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontFamily: 'Satoshi-Bold',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  );
                                } else {
                                  return Shimmer(child: Container(
                                    width: 100,
                                    height: 50,
                                  ), gradient: LinearGradient(colors: [
                                    Color(0x8388888A)
                                  ]));
                                }
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                        leading: Icon(Icons.rule, color: Colors.white,),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => theTerms()));
                              },
                              child: Text("Terms", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        )
                    ),
                    ListTile(
                        leading: Icon(Icons.info, color: Colors.white,),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => registeredLicensePlate()));
                              },
                              child: Text("Information", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        )
                    ),
                    ListTile(
                        leading: Icon(Icons.settings, color: Colors.white,),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {

                              },
                              child: Text("Setting", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        )
                    ),
                    ListTile(
                        leading: Icon(Icons.output, color: Colors.white,),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                  currentUser.signOut().then((value) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
                                  });
                              },
                              child: Text("Sign Out", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
