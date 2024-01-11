import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:smart_parking/Services/mqttManager.dart';

class ReservationProvider extends ChangeNotifier {
  final MqttManager _mqttManager = MqttManager();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<bool> _availableSpots = List.generate(30, (index) => true);
  bool _isConnected = false;
  int _numberOfReservations = 0;

  List<bool> get availableSpots => _availableSpots;
  bool get isConnected => _isConnected;
  int get numberOfReservations => _numberOfReservations;

  Future<void> connect() async {
    await _mqttManager.connect('my_client_identifier', 'nam54828', 'DoDucNam123');
    _mqttManager.subscribe('SmartParking/reservation');
    MqttManager.client?.updates?.listen(_onMessage);
    _isConnected = true;
    await _updateAvailableSpotsFromFirebase();
    notifyListeners();
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    final MqttPublishMessage message = event[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
    final topic = event[0].topic;

    print('Received message from topic: $topic, payload: $payload');

    if (topic == 'SmartParking/reservation') {
      _handleReservationMessage(payload);
    }
  }

  void _handleReservationMessage(String message) {
    if (message.startsWith('Spot reserved')) {
      int spotIndex = int.tryParse(message.split(' ')[2]) ?? -1;
      if (spotIndex >= 0 && spotIndex < _availableSpots.length) {
        _reserveSpot(spotIndex - 1);
      }
    }
  }

  Future<void> _reserveSpot(int spotIndex) async {
    _availableSpots[spotIndex] = false;
    await _firestore.collection('parking_reservations').add({
      'spotIndex': spotIndex + 1,
      'timestamp': FieldValue.serverTimestamp(),
    });
    notifyListeners();
  }

  Future<void> _updateAvailableSpotsFromFirebase() async {
    QuerySnapshot snapshot = await _firestore.collection('parking_reservations').get();

    _availableSpots = List.generate(_availableSpots.length, (index) => true);
    for (QueryDocumentSnapshot reservation in snapshot.docs) {
      int reservedSpotIndex = (reservation.data() as Map<String, dynamic>)['spotIndex'] - 1;
      _availableSpots[reservedSpotIndex] = false;
    }
    notifyListeners();
  }

  Future<void> makeReservation(BuildContext context,int spotIndex) async {
    if (_numberOfReservations < 3) {
      if (_availableSpots[spotIndex]) {
        try {
          CollectionReference reservations = _firestore.collection(
              'parking_reservations');
          DateTime currentTime = DateTime.now();
          DateTime expirationTime = currentTime.add(Duration(minutes: 30));
          User? user = _auth.currentUser;
          String? userID = user?.uid;

          await reservations.add({
            'spotIndex': spotIndex + 1,
            'timestamp': FieldValue.serverTimestamp(),
            'expirationTime': expirationTime,
            'userID': userID,
          });

          _mqttManager.publish(
              'SmartParking/reservation', 'Spot reserved: ${spotIndex + 1}');

          _numberOfReservations++;
          _availableSpots[spotIndex] = false;
          notifyListeners();

          Future.delayed(Duration(minutes: 30), () async {
            _availableSpots[spotIndex] = true;
            notifyListeners();
          });
        } catch (e) {
          print('Error making reservation: $e');
        }
      }
    } else {
        showDialog(context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Maximum Reservations'),
                content: Text(
                    'You have booked the maximum number of seats for the day!',
                textAlign: TextAlign.center,),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: Text("OK"))
                ],
              );
            });
    }
  }


  void disconnect() {
    _mqttManager.unsubscribe('SmartParking/reservation');
    _mqttManager.disconnect();
    _isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
