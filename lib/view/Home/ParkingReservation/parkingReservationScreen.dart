import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking/Provider/reservation_provider.dart';


import '../../../Services/mqttManager.dart';

import 'package:shimmer/shimmer.dart';

import '../../profile/terms.dart';



class ParkingReservationScreen extends StatefulWidget {
  @override
  _ParkingReservationScreenState createState() => _ParkingReservationScreenState();
}

class _ParkingReservationScreenState extends State<ParkingReservationScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ReservationProvider>(context, listen: false).connect();
  }
  @override
  void dispose() {
    Provider.of<ReservationProvider>(context, listen: false).disconnect();
    super.dispose();
  }

  Widget buildParkingSpots(List<bool> spots, int startZoneIndex) {
    final model = Provider.of<ReservationProvider>(context);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(spots.length, (index) {
        final globalIndex = startZoneIndex + index;
        return GestureDetector(
          onTap: () {
            model.makeReservation(context, globalIndex);
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
                  color: spots[index] ? Colors.white : Colors.black,
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
    final model = Provider.of<ReservationProvider>(context);
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
                'Available Parking Spots: ${model.availableSpots.where((spot) => spot).length}/30',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              if (!model.isConnected)
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: GridView(
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
                          buildParkingSpots(model.availableSpots.sublist(0, 10), 0),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Zone B',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          buildParkingSpots(model.availableSpots.sublist(10, 20), 10),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Zone C',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          buildParkingSpots(model.availableSpots.sublist(20, 30), 20),
                        ],
                      ),
                    ],
                  ),
                ),
              if (model.isConnected)
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
                      buildParkingSpots(model.availableSpots.sublist(0, 10), 0),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Zone B',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      buildParkingSpots(model.availableSpots.sublist(10, 20), 10),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Zone C',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      buildParkingSpots(model.availableSpots.sublist(20, 30), 20),
                    ],
                  ),
                ],
              ) ,
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
                      Text("EMPTY", style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                        fontWeight: FontWeight.bold
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
                      Text("FILL", style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.bold
                      ),)
                    ],
                  )
                ],
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          RichText(
                            softWrap: true, // Thêm thuộc tính này để cho phép tự động xuống hàng
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Note: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "Please read ",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "the terms ",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => theTerms()),
                                    ),
                                ),
                                TextSpan(
                                  text: "carefully before booking",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
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