import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:smart_parking/Services/mqttManager.dart';

class NotificationProvider extends ChangeNotifier {
  final MqttManager _mqttManager = MqttManager();
  int _unreadNotifications = 0;
  bool _isConnected = false;

  int get unreadNotifications => _unreadNotifications;
  bool get isConnected => _isConnected;

  void connect(BuildContext context) async {
    await _mqttManager.connect('my_client_identifier', 'nam54828', 'DoDucNam123');
    _mqttManager.subscribe('SmartParking/flame');
    MqttManager.client?.updates?.listen((event){
      _onMessage(context, event);
    });
    _isConnected = true;
    notifyListeners();
  }

  void _onMessage(BuildContext context, List<MqttReceivedMessage<MqttMessage>> event) {
    final MqttPublishMessage message = event[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
    final topic = event[0].topic;

    print('Received message from topic: $topic, payload: $payload');

    if (payload == '0') {
      FirebaseFirestore.instance.collection('notifications').add({
        'topic': event[0].topic,
        'payload': payload,
        'timestamp': DateTime.now(),
      });
      _showDialog(context);
    } else {
      print('Failed to connect');
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification'),
          content: Text('The parrking lot is fire'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void disconnect() {
    _mqttManager.unsubscribe('SmartParking/flame');
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
