import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/Login/login.dart';

class forgotPassword extends StatelessWidget {
   final TextEditingController emailController = TextEditingController();
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.black,
       appBar: AppBar(
         backgroundColor: Colors.black,
         centerTitle: true,
         title: Text("QUÊN MẬT KHẨU", style: TextStyle(
             fontSize: 15,
             fontWeight: FontWeight.bold,
              color: Colors.white
         ),),
         leading: IconButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
         },
           icon: Icon(Icons.keyboard_backspace), color:  Colors.white,),
       ),
       body: Container(
         child: Column(
           children: [
             Container(
               child: Column(
                 children: [
                   Image.asset("images/logo.png", height: 140,width: 140,),
                   SizedBox(
                     height: 15,
                   ),
                   Center(child: Text("Vui lòng điền địa chỉ email của bạn để được nhận mã \nxác nhận.",style: TextStyle(
                       color: Colors.white
                   ),
                     textAlign: TextAlign.center,)),
                   SizedBox(
                     height: 15,
                   ),
                   Padding(
                     padding: const EdgeInsets.all(15.0),
                     child:  TextFormField(
                       decoration: InputDecoration(
                         border: UnderlineInputBorder(
                           borderSide: BorderSide(color: Colors.white),
                         ),
                         enabledBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: Colors.blue),
                         ),
                         focusedBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: Colors.blue),
                         ),
                         hintText: "Email *",
                         hintStyle: TextStyle(
                             color: Colors.white,
                             fontSize: 10
                         ),
                       ),
                       style: TextStyle(
                           color: Colors.white
                       ),
                       controller: emailController,
                     ),
                   ),
                   SizedBox(
                     height: 15,
                   ),
                   ElevatedButtonTheme(
                     data: ElevatedButtonThemeData(
                       style: ElevatedButton.styleFrom(
                         primary: Colors.blue,
                       ),
                     ),
                     child: Container(
                       padding: EdgeInsets.only(left: 10, right: 10),
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
                             var forgotEmail = emailController.text.trim();
                             try{
                               FirebaseAuth.instance.sendPasswordResetEmail(email: forgotEmail).then((value) => {
                                 print("Email Sent!"),
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => login()))
                               });
                             }on FirebaseAuthException catch(e){
                               print("Error $e");
                             }
                           },
                           child: Text("SENT")),
                     ),
                   )
                 ],
               ),
             )
           ],
         ),
       ),
     );
   }
}