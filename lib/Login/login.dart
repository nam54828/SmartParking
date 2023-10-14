import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/Register/register.dart';
import 'package:smart_parking/onBoarding/onBoarding3.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void showFailMessage(){
    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
      title: const Text("Login"),
      content: Text("Login Failed"),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
    }, child: Text("OK"))
      ],
    ));
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset("images/logo.png", height: 150, width: 150,)),
            Center(
              child: Text(
                "LOGIN", style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(20, 30, 30, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email:", style: TextStyle(
                      color: Colors.white
                    ),),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Color.fromRGBO(1, 4, 108, 1),),

                      ),
                      controller: emailController,
                      validator: (value){
                        if (value!.isEmpty) {
                          return ("Trường hợp này không được để trống.");
                        }
                        if (!RegExp(
                            "^[a-zA-Z0-9+_.-]+@[a-z0-9A-Z.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Vui lòng nhập Email hợp lệ");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        emailController.text = value!;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Password:", style: TextStyle(
                        color: Colors.white
                    ),),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password, color: Color.fromRGBO(1, 4, 108, 1),),
                      ),
                      style: TextStyle(
                          color: Colors.white
                      ),
                      controller: passwordController,
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Mật khẩu bắt buộc để đăng nhập");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Mật khẩu không hợp lệ");
                        }
                      },
                      onSaved: (value) {
                        passwordController.text = value!;
                      },
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),
            TextButton(onPressed: (){},
                child: Text("Forgot password?")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text,
                          password: passwordController.text)
                          .then((value){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => onBoarding3()));
                      }).onError((error, stackTrace) {
                        showFailMessage();
                      });
                    },
                    style:
                    ElevatedButton.styleFrom(primary: Colors.orangeAccent),
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: Center(
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 180,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Column(
                    children: [
                      Text("Don't have an account?", style: TextStyle(
                        color: Colors.white
                      ),)
                    ],
                  ),
                SizedBox(
                  child: TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>register()));
                    },
                    child: Text("REGISTER", style: TextStyle(
                      color: Color.fromRGBO(1, 4, 108, 1)
                    ),),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
