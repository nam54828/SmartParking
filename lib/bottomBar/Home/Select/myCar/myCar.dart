import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:smart_parking/bottomBar/Home/Select/myCar/registeredLicensePlate.dart';

class myCar extends StatefulWidget {
  const myCar({Key? key}) : super(key: key);

  @override
  State<myCar> createState() => _myCarState();
}

class _myCarState extends State<myCar> {
  final bksController = TextEditingController();
  final rfidController = TextEditingController();

  final databaseRef = FirebaseDatabase.instance.reference();

  final currentUser = FirebaseAuth.instance;

  User? user = FirebaseAuth.instance.currentUser;
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
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Center(
      //         child: Image.asset("images/logo.png", fit: BoxFit.cover, height: 250,),
      //       ),
      //       Padding(padding: EdgeInsets.all(12),
      //         child: Column(
      //           children: [
      //             TextFormField(
      //               decoration: InputDecoration(
      //                 hintText: "Please Enter BKS",
      //                 hintStyle: TextStyle(
      //                     color: Color.fromRGBO(136, 136, 138, 0.5)
      //                 ),
      //                 prefixIcon: Icon(Icons.car_crash, color: Colors.white,),
      //
      //               ),
      //               style: TextStyle(
      //                   color: Colors.white
      //               ),
      //               controller: bksController,
      //               onSaved: (value) {
      //                 bksController.text = value!;
      //               },
      //             ),
      //             SizedBox(
      //               height: 30,
      //             ),
      //             TextFormField(
      //               decoration: InputDecoration(
      //                 hintText: "Please Enter RFID Card",
      //                 hintStyle: TextStyle(
      //                     color: Color.fromRGBO(136, 136, 138, 0.5)
      //                 ),
      //                 prefixIcon: Icon(Icons.add_card, color: Colors.white,),
      //
      //               ),
      //               style: TextStyle(
      //                   color: Colors.white
      //               ),
      //               controller: rfidController,
      //               onSaved: (value) {
      //                 rfidController.text = value!;
      //               },
      //             ),
      //             SizedBox(
      //               height: 30,
      //             ),
      //             ElevatedButtonTheme(
      //               data: ElevatedButtonThemeData(
      //                 style: ElevatedButton.styleFrom(
      //                   primary: Colors.blue,
      //                 ),
      //               ),
      //               child: Container(
      //                 padding: EdgeInsets.only(left: 5, right: 5),
      //                 width: MediaQuery.of(context).size.width,
      //                 child: ElevatedButton(
      //                     style: ButtonStyle(
      //                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //                         RoundedRectangleBorder(
      //                           borderRadius: BorderRadius.circular(18.0),
      //                         ),
      //                       ),
      //                     ),
      //                     onPressed: () async{
      //
      //                       final bks = bksController.text;
      //                       final rfid = rfidController.text;
      //
      //                       final conn = await getConnection();
      //
      //
      //                       try {
      //                         await conn.query(
      //                           'INSERT INTO UserRFID (userId, bks, rfid) VALUES (?, ?, ?)',
      //                           [user!.uid, bks, rfid],
      //                         );
      //
      //                       } catch (e) {
      //                         print(e);
      //                       } finally {
      //                         await conn.close();
      //                       }
      //                       // Save to Firebase Realtime Database
      //                       if (user != null) {
      //                         try {
      //                           // await databaseRef.child('UserRFID').child(user!.uid).push().set({
      //                           //   'bks': bks,
      //                           //   'rfid': rfid,
      //                           // });
      //                           // await FirebaseFirestore.instance.collection('UserRFID').add({
      //                           //   'userId': user!.uid,
      //                           //   'bks':bks,
      //                           //   'rfid':rfid,
      //                           // });
      //                           await FirebaseFirestore.instance.collection('UserRFID').doc(user!.uid).set({
      //                             'userId': user!.uid,
      //                             'bks': bks,
      //                             'rfid': rfid,
      //                           });
      //
      //                           // Show a success SnackBar
      //                           ScaffoldMessenger.of(context).showSnackBar(
      //                             SnackBar(
      //                               content: Text('You have successfully registered your license plate'),
      //                               duration: Duration(seconds: 2),
      //                             ),
      //                           );
      //
      //                         } catch (e) {
      //                           print('Error saving data: $e');
      //                         }
      //                       } else {
      //                         print('User not authenticated');
      //                       }
      //                     },
      //                     child: Text("SUBMIT", style: TextStyle(
      //                         color: Colors.white,
      //                         fontWeight: FontWeight.bold
      //                     ),)),
      //               ),
      //             )
      //           ],
      //         ),
      //
      //       )
      //     ],
      //   ),
      // ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("UserRFID").where("userId", isEqualTo: currentUser.currentUser!.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.docs.isNotEmpty){
              return Column(
                children: [
                  Center(
                    child: Image.asset("images/logo.png", fit: BoxFit.cover, height: 250,),
                  ),
                  Padding(padding: EdgeInsets.all(12),
                  child: TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => registeredLicensePlate()));
                  },
                      child: Text("You have registered the license plate. Please check back here!", textAlign: TextAlign.center,)),)
                ],
              );
            } else{
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Image.asset("images/logo.png", fit: BoxFit.cover, height: 250,),
                    ),
                    Padding(padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
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
                            controller: bksController,
                            onSaved: (value) {
                              bksController.text = value!;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Please Enter RFID Card",
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(136, 136, 138, 0.5)
                              ),
                              prefixIcon: Icon(Icons.add_card, color: Colors.white,),

                            ),
                            style: TextStyle(
                                color: Colors.white
                            ),
                            controller: rfidController,
                            onSaved: (value) {
                              rfidController.text = value!;
                            },
                          ),
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
                                        'INSERT INTO UserRFID (userId, bks, rfid) VALUES (?, ?, ?)',
                                        [user!.uid, bks, rfid],
                                      );

                                    } catch (e) {
                                      print(e);
                                    } finally {
                                      await conn.close();
                                    }
                                    // Save to Firebase Realtime Database
                                    if (user != null) {
                                      try {
                                        // await databaseRef.child('UserRFID').child(user!.uid).push().set({
                                        //   'bks': bks,
                                        //   'rfid': rfid,
                                        // });
                                        // await FirebaseFirestore.instance.collection('UserRFID').add({
                                        //   'userId': user!.uid,
                                        //   'bks':bks,
                                        //   'rfid':rfid,
                                        // });
                                        await FirebaseFirestore.instance.collection('UserRFID').doc(user!.uid).set({
                                          'userId': user!.uid,
                                          'bks': bks,
                                          'rfid': rfid,
                                        });

                                        // Show a success SnackBar
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('You have successfully registered your license plate'),
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
                      ),

                    )
                  ],
                ),
              );
            }
          } else{
            return CircularProgressIndicator();
          }
        }
      ),
    ));
  }
}
