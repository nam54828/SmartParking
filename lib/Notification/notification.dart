import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../Services/mqttManager.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final MqttManager _mqttManager = MqttManager();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() async {
    await _mqttManager.connect('my_client_identifier', 'nam54828', 'DoDucNam123');
    _mqttManager.subscribe('SmartParking/flame');
    MqttManager.client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> event) {
      final MqttPublishMessage receivedMessage = event[0].payload as MqttPublishMessage;
      final String payload = MqttPublishPayload.bytesToStringAsString(receivedMessage.payload.message);
      print('Received message from topic: ${event[0].topic}, payload: $payload');

      if (payload == '1') {
        _firestore.collection('notifications').add({
          'topic': event[0].topic,
          'payload': payload,
          'timestamp': DateTime.now(),
        });

        setState(() {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Notification'),
                content: Text('Warning: The parking lot is on fire'),
              );
            },
          );
        });
      } else {
        print('Failed to connect');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('MQTT Notification', style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Colors.black,
      ),
      body: NotificationsList()
    );
  }
}

class NotificationsList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('notifications').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator()); // Loading indicator
        }
        final notifications = snapshot.data!.docs;

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final timestamp = notifications[index]['timestamp'].toDate(); // Convert Firestore timestamp to DateTime

            return Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text("Warning: The parking lot is on fire",
                style: TextStyle(
                  color: Colors.white
                ),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time: ${_formatDateTime(timestamp)}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    // Format the DateTime as per your preference
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }
}