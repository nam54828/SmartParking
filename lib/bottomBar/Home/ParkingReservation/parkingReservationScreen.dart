import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../../Services/mqttManager.dart'; // Import Firestore

class ParkingReservationScreen extends StatefulWidget {
  @override
  _ParkingReservationScreenState createState() => _ParkingReservationScreenState();
}

class _ParkingReservationScreenState extends State<ParkingReservationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MqttManager _mqttManager = MqttManager();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int numberOfReservations = 0;
  int totalParkingSpots = 30;
  List<bool> availableSpots = List.generate(30, (index) => true);
  @override
  void initState() {
    super.initState();
    _connect();

    // Kiểm tra và xóa thông tin đặt chỗ sau khi hết hạn mỗi 1 phút
    Timer.periodic(Duration(minutes: 1), (Timer t) {
      checkAndRemoveExpiredReservations();
    });
  }
  // Hàm kiểm tra và xóa thông tin đặt chỗ sau khi hết hạn
  void checkAndRemoveExpiredReservations() async {
    QuerySnapshot snapshot = await _firestore.collection('parking_reservations').get();
    DateTime currentTime = DateTime.now();

    for (QueryDocumentSnapshot reservation in snapshot.docs) {
      DateTime expirationTime = (reservation.data() as Map)['expirationTime'].toDate();
      if (currentTime.isAfter(expirationTime)) {
        // Xóa thông tin đặt chỗ đã hết hạn
        await _firestore.collection('parking_reservations').doc(reservation.id).delete();
        // Cập nhật trạng thái của chỗ đỗ xe
        int expiredSpotIndex = (reservation.data() as Map)['spotIndex'] - 1;
        setState(() {
          availableSpots[expiredSpotIndex] = true;
        });
      }
    }
  }
  void _connect() async {
    await _mqttManager.connect('my_client_identifier', 'nam54828', 'DoDucNam123');
    _mqttManager.subscribe('Smartparking/reservation');
    MqttManager.client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> event) {
      final MqttPublishMessage receivedMessage = event[0].payload as MqttPublishMessage;
      final String payload = MqttPublishPayload.bytesToStringAsString(receivedMessage.payload.message);
            print('Received message from topic: ${event[0].topic}, payload: $payload');
       });
  }
  Future<void> makeReservation(int spotIndex) async {
    if (numberOfReservations < 3) {
      if (availableSpots[spotIndex]) {
        try {
          CollectionReference reservations = _firestore.collection('parking_reservations');
          DateTime currentTime = DateTime.now();
          DateTime expirationTime = currentTime.add(Duration(minutes: 30)); // Thời gian hết hạn: thời gian hiện tại cộng thêm 30 phút
          User? user = _auth.currentUser;
          String? userID = user?.uid;
          // Thêm thông tin đặt chỗ vào Firestore
          await reservations.add({
            'spotIndex': spotIndex + 1,
            'timestamp': FieldValue.serverTimestamp(),
            'expirationTime': expirationTime,
            'userID': userID, // Thay thế bằng thông tin người dùng thực tế
          });
          // Publish the reservation spot to ESP32 via MQTT
          _mqttManager.publish('SmartParking/reservation', 'Spot reserved: ${spotIndex + 1}');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Successful Reservation'),
                content: Text('Parking spot ${spotIndex + 1} is reserved for 30 minutes.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );

          setState(() {
            numberOfReservations++;
            availableSpots[spotIndex] = false;
          });

          // Delayed logic to free up the spot after 30 minutes
          Future.delayed(Duration(minutes: 30), () {
            setState(() {
              availableSpots[spotIndex] = true;
            });
          });
        } catch (e) {
          print('Error making reservation: $e');
          // Handle error - You might want to display an error message to the user
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Spot Already Reserved'),
              content: Text('Parking spot ${spotIndex + 1} is already reserved.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Maximum Reservations Reached'),
            content: Text('You have reached the maximum number of reservations for today.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
  Widget buildParkingSpots(List<bool> spots, int startZoneIndex) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(spots.length, (index) {
        final globalIndex = startZoneIndex + index;
        return GestureDetector(
          onTap: () {
            makeReservation(globalIndex);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: spots[index] ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: spots[index] ? Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Spot ${globalIndex + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Reservation'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Available Parking Spots: ${availableSpots.where((spot) => spot).length}/$totalParkingSpots',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 550,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zone A',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      buildParkingSpots(availableSpots.sublist(0, 10), 0),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Zone B',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      buildParkingSpots(availableSpots.sublist(10, 20), 10),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Zone C',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      buildParkingSpots(availableSpots.sublist(20, 30), 20),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.rectangle_rounded, color: Colors.green,),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Còn trống", style: TextStyle(
                          color: Colors.black
                      ),)
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.rectangle_rounded, color: Colors.red,),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Đã đặt", style: TextStyle(
                          color: Colors.black
                      ),)
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "Chú ý: ", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            )
                            ),
                            TextSpan(
                              text: "Vui lòng đọc kỹ các điều khoản trước khi đặt chỗ",
                              style: TextStyle(
                                color: Colors.black
                              )
                            )
                          ]
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}