import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/Notification/notification.dart';
import 'package:smart_parking/bottomBar/Home/Select/selectPages.dart';

import 'Banner/bannner.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final currentUser = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    User? _user = currentUser.currentUser;
    if (_user != null) {
      await _user.reload(); // Reload the user to get the latest user data
      _user = currentUser.currentUser; // Fetch the user again to get updated data
      setState(() {
        user = _user;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 90,
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Hello", style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                              ),
                              ),
                              TextSpan(
                                text: " User,", style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                              )
                              ),
                              if (user != null)
                                TextSpan(
                                    text: " ${user!.email}", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  overflow: TextOverflow.clip
                                ),
                                ),
                              TextSpan(
                                text: "\n\nHave a nice day!"
                              )
                            ]
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          children: [
                            IconButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage() ));
                            },
                                icon: Icon(Icons.notifications_active_outlined, color: Colors.white,))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text("Today", style: TextStyle(
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold
            //     ),),
            //   ],
            // ),
            Container(

              child: Image.asset("images/home.jpg")
            ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,15,0,15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ),
              Container(
                height: 400,
                child: Expanded(
                  child: selectPages(),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}