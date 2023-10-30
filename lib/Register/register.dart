import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/Login/login.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final databaseRef = FirebaseDatabase.instance.reference();
  String? confirmPasswordError;

  void showFailedMessage(){
    showDialog(context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Register"),
          content: Text("Failed"),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text("REGISTER", style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                Padding(padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("EMAIL:", style: TextStyle(
                        color: Colors.white
                      ),),
                      SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.white,
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email, color: Color.fromRGBO(1, 4, 108, 1)),
                            ),
                            controller: emailController,
                            validator: (value){
                              if(value!.isEmpty){
                                return ("Vui lòng nhập email");
                              }
                              if (!RegExp(
                                  "^[a-zA-Z0-9+_.-]+@[a-z0-9A-Z.-]+.[a-z]")
                                  .hasMatch(value)) {
                                return ("Vui lòng nhập Email hợp lệ");
                              }
                              return null;
                            },
                            onSaved: (value){
                              emailController.text = value!;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("USER NAME:", style: TextStyle(
                        color: Colors.white
                      ),),
                      SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.white,
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person, color: Color.fromRGBO(1, 4, 108, 1)),
                            ),
                            controller: usernameController,
                            validator: (value){
                              if(value!.isEmpty){
                                return ("Vui lòng nhập họ và tên");
                              }
                            },
                            onSaved: (value){
                              usernameController.text = value!;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("PHONE:", style: TextStyle(
                        color: Colors.white
                      ),),
                      SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.white,
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone, color: Color.fromRGBO(1, 4, 108, 1)),
                            ),
                            controller: phoneController,
                            validator: (value){
                              if (value!.isEmpty){
                                return ("Vui lòng nhập số điện thoại");
                              }
                            },
                            onSaved: (value){
                              phoneController.text = value!;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("PASSWORD", style: TextStyle(
                        color: Colors.white
                      ),),
                      SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.white,
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.password, color: Color.fromRGBO(1, 4, 108, 1)),
                            ),
                            controller: passwordController,
                            validator: (value){
                              RegExp regex = RegExp(r'^.{6,}$');
                              if (value!.isEmpty){
                                return ("Vui lòng nhập mật khẩu");
                              }
                              if (!regex.hasMatch(value)) {
                                return ("Mật khẩu không hợp lệ");
                              }
                            },
                            onSaved: (value){
                              passwordController.text = value!;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("CONFIRM PASSWORD:", style: TextStyle(
                        color: Colors.white
                      ),),
                      SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.white,
                          child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.password, color: Color.fromRGBO(1, 4, 108, 1)),
                              ),
                              controller: confirmPasswordController,
                              validator: (value) {
                                if (value != passwordController.text) {
                                  confirmPasswordError = "Passwords do not match";
                                  return null; // Return null to indicate no error to the TextFormField
                                }
                                confirmPasswordError = null;
                                return null;
                              }
                          ),
                        ),
                      ),
                      if (confirmPasswordError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            confirmPasswordError!,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                    ],
                  ),
                ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (passwordController.text != confirmPasswordController.text) {
                              // Passwords don't match, show an error message
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Passwords do not match.'),
                                backgroundColor: Colors.red,
                              ));
                            } else {
                              // Passwords match, proceed with registration
                              FirebaseAuth.instance.createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text
                              ).then((value) {
                                databaseRef.child('users').child(value.user!.uid).set({
                                  'email': emailController.text,
                                  'user': usernameController.text,
                                  'phone': phoneController.text,
                                  'password': passwordController.text,
                                  'confirmPassword': confirmPasswordController.text
                                });
                                Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
                              }).onError((error, stackTrace) {
                                showFailedMessage();
                              });
                            }
                          }
                        },
                        color: Color.fromRGBO(1, 4, 108, 1),
                        minWidth: 330,
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "ĐĂNG KÝ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("Do you already have an account?",
                        style: TextStyle(
                          color: Colors.white
                        ),)
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> login()));
                        }, child: Text("LOGIN"))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
      ),
    ));
  }
}
