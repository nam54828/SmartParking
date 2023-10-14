import 'package:flutter/material.dart';

import '../Login/login.dart';
import 'onBoarding2.dart';

class onBoarding1 extends StatelessWidget {
  const onBoarding1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 35,
                  width: 70,
                  child: TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>login()));
                  }, child: Text(
                    "Skip", style: TextStyle(
                    color: Colors.white,
                    fontSize: 14
                  ),
                  ),),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(1, 4, 108, 1),
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 250,
            ),
            Center(
              child: Column(
                children: [
                  Text("IOT Internet of Things Technology",style: TextStyle(
                    color: Color.fromRGBO(1, 4, 108, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Container(
                    width: 350,
                    margin: EdgeInsets.only(top: 10),
                    child: Text("Apply Internet of Things (IOT) technology to monitor the system.",style: TextStyle(
                        color: Colors.white,
                        fontSize: 14
                    ),
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>onBoarding1()));
                    }, icon: Icon(Icons.radio_button_checked, color: Color.fromRGBO(1, 4, 108, 1), size: 16,))
                  ],
                ),
                Column(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>onBoarding2()));
                    }, icon: Icon(Icons.radio_button_unchecked, color: Color.fromRGBO(1, 4, 108, 1), size: 16,))
                  ],
                ),
                Column(
                  children: [
                    IconButton(onPressed: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>onBoarding1()));
                    }, icon: Icon(Icons.radio_button_unchecked, color: Color.fromRGBO(1, 4, 108, 1),size: 16,))
                  ],
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> onBoarding2()));
              }, child: Text(
                "NEXT",style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(1, 4, 108, 1),
              ),),
            )

          ],
        ),
      ) ,
    ));
  }
}
