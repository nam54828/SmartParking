import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';
import 'package:smart_parking/Provider/notification_provider.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<NotificationProvider>(context, listen: false).connect();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<NotificationProvider>(context,listen: false).disconnect();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('MQTT Notification', style: TextStyle(
          color: Colors.white,
          fontSize: 18
        ),),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace_sharp, color: Colors.white,),
        ),
      ),
      body: NotificationsList()
    );
  }
}

class NotificationsList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child){
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('notifications').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final notifications = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final timestamp = notifications[index]['timestamp'].toDate();

                return Dismissible(
                  key:Key(notifications[index].id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction){
                    _firestore.collection('notifications').doc(notifications[index].id).delete();
                  },
                  child: Container(
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
                  ),
                );
              },
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