import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:smart_parking/Notification/notification.dart';
import 'package:smart_parking/bottomBar/Home/Select/selectPages.dart';

import '../../Services/mqttManager.dart';
import 'Banner/bannner.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final currentUser = FirebaseAuth.instance;
  User? user;
  int unreadNotifications = 0; // Tạo 1 biến để lưu số lượng chưa đọc
  final MqttManager _mqttManager = MqttManager();
  @override
  void initState() {
    super.initState();
  _connect();
    getUserInfo();
  }

  void _connect() async {
    await _mqttManager.connect('my_client_identifier', 'nam54828', 'DoDucNam123');
    _mqttManager.subscribe('SmartParking/flame');
    MqttManager.client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> event) {
      final MqttPublishMessage receivedMessage = event[0].payload as MqttPublishMessage;
      final String payload = MqttPublishPayload.bytesToStringAsString(receivedMessage.payload.message);
      print('Received message from topic: ${event[0].topic}, payload: $payload');


    });
  }

  Future<void> getUserInfo() async {
    User? _user = currentUser.currentUser;
    if (_user != null) {
      await _user.reload(); // Reload the user to get the latest user data
      _user = currentUser.currentUser; // Fetch the user again to get updated data
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('notifications').where('read', isEqualTo: false).get();
      int unreadCount = querySnapshot.docs.length; // Count unread notifications
      setState(() {
        user = _user;
        unreadNotifications = unreadCount;
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
                                icon: Icon(Icons.notifications_active_outlined, color: Colors.white,)),
                            if (unreadNotifications > 0)
                              Positioned(
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$unreadNotifications',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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