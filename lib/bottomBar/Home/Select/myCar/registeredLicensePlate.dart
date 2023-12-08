import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:smart_parking/bottomBar/Home/Select/myCar/myCar.dart';

class registeredLicensePlate extends StatefulWidget {
  const registeredLicensePlate({Key? key}) : super(key: key);

  @override
  State<registeredLicensePlate> createState() => _registeredLicensePlateState();
}

class _registeredLicensePlateState extends State<registeredLicensePlate> {
  final bksController = TextEditingController();
  final rfidController = TextEditingController();

  final databaseRef = FirebaseDatabase.instance.reference();

  User? user = FirebaseAuth.instance.currentUser;

  final currentUser = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    // Load existing data when the widget is created
    loadData();
  }
  Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: 'db4free.net',
      port: 3306,
      user: 'doaniotnhom2',
      db: 'doaniotnhom2',
      password: 'smartparking',
    );

    return await MySqlConnection.connect(settings);
  }
  Future<void> loadData() async {
    if (user != null) {
      try {
        // Retrieve data from Firestore
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection("UserRFID")
            .where("userId", isEqualTo: currentUser.currentUser!.uid)
            .get();

        if (snapshot.docs.isNotEmpty) {
          Map<String, dynamic> data = snapshot.docs.first.data();

          setState(() {
            bksController.text = data['bks'] ?? '';
            rfidController.text = data['rfid'] ?? '';
          });
        }
      } catch (e) {
        print('Error loading data: $e');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("My Car", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_left, color: Colors.white,)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset("images/logo.png", fit: BoxFit.cover, height: 250,),
            ),
            Padding(padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("UserRFID")
                        .where("userId", isEqualTo: currentUser.currentUser!.uid).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if(snapshot.hasData){
                        if(snapshot.data!.docs.isNotEmpty){
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              var data = snapshot.data!.docs[i];
                              return
                                TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Please Enter BKS",
                                      hintStyle: TextStyle(
                                          color: Color.fromRGBO(136, 136, 138, 0.5)
                                      ),
                                      prefixIcon: Icon(Icons.car_crash, color: Colors.white,),

                                    ),
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                    controller: bksController
                                      ..text = data["bks"]
                                );
                            },
                          );
                        } else {
                          return Center(
                            child: TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => myCar()));
                            },
                                child: Text("If you have not registered your license plate yet, please click here!", textAlign: TextAlign.center,)),
                          );
                        }
                      }else {
                        return CircularProgressIndicator();
                      }
              }),
                  SizedBox(
                    height: 30,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("UserRFID")
                          .where("userId", isEqualTo: currentUser.currentUser!.uid).snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data!.docs.isNotEmpty){
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                var data = snapshot.data!.docs[i];
                                return
                                  TextFormField(
                                      decoration: InputDecoration(
                                        hintText: "Please Enter BKS",
                                        hintStyle: TextStyle(
                                            color: Color.fromRGBO(136, 136, 138, 0.5)
                                        ),
                                        prefixIcon: Icon(Icons.car_crash, color: Colors.white,),

                                      ),
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                      controller: rfidController
                                        ..text = data["rfid"]
                                  );
                              },
                            );
                          }else{
                            return Container();
                          }
                        }else {
                          return   CircularProgressIndicator();
                        }
                      }),

                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("UserRFID")
                          .where("userId", isEqualTo: currentUser.currentUser!.uid).snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data!.docs.isNotEmpty){
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                var data = snapshot.data!.docs[i];
                                return
                                 Column(
                                   children: [
                                     SizedBox(
                                       height: 30,
                                     ),
                                     ElevatedButtonTheme(
                                       data: ElevatedButtonThemeData(
                                         style: ElevatedButton.styleFrom(
                                           primary: Colors.blue,
                                         ),
                                       ),
                                       child: Container(
                                         padding: EdgeInsets.only(left: 5, right: 5),
                                         width: MediaQuery.of(context).size.width,
                                         child: ElevatedButton(
                                             style: ButtonStyle(
                                               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                 RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.circular(18.0),
                                                 ),
                                               ),
                                             ),
                                             onPressed: () async{

                                               final bks = bksController.text;
                                               final rfid = rfidController.text;

                                               final conn = await getConnection();


                                               try {
                                                 await conn.query(
                                                   'UPDATE UserRFID SET bks = ?, rfid = ? WHERE userId = ? ',
                                                   [bks, rfid, user!.uid],
                                                 );

                                               } catch (e) {
                                                 print(e);
                                               } finally {
                                                 await conn.close();
                                               }

                                               if (user != null) {
                                                 try {
                                                   await FirebaseFirestore.instance.collection('UserRFID').doc(user!.uid).set({
                                                     'userId': user!.uid,
                                                     'bks':bks,
                                                     'rfid':rfid,
                                                   });

                                                   ScaffoldMessenger.of(context).showSnackBar(
                                                     SnackBar(
                                                       content: Text('You have successfully'),
                                                       duration: Duration(seconds: 2),
                                                     ),
                                                   );
                                                 } catch (e) {
                                                   print('Error saving data: $e');
                                                 }
                                               } else {
                                                 print('User not authenticated');
                                               }

                                               if (user != null) {
                                                 try {
                                                   await   databaseRef.child('UserRFID').child(user!.uid).update({
                                                     'userId': user!.uid,
                                                     'bks': bks,
                                                     'rfid': rfid,
                                                   });

                                                   ScaffoldMessenger.of(context).showSnackBar(
                                                     SnackBar(
                                                       content: Text('You have successfully'),
                                                       duration: Duration(seconds: 2),
                                                     ),
                                                   );
                                                 } catch (e) {
                                                   print('Error saving data: $e');
                                                 }
                                               } else {
                                                 print('User not authenticated');
                                               }
                                             },
                                             child: Text("SUBMIT", style: TextStyle(
                                                 color: Colors.white,
                                                 fontWeight: FontWeight.bold
                                             ),)),
                                       ),
                                     )
                                   ],
                                 );
                              },
                            );
                          }else{
                            return Container();
                          }
                        }else {
                          return   CircularProgressIndicator();
                        }
                      }),
                ],
              ),

            )
          ],
        ),
      ),
    ));
  }
}
