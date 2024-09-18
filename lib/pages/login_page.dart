import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:translation/pages/home_page.dart';
import 'package:translation/pages/register_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final loginMsg = SnackBar(
    content: Text('Logged In'),
  );

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Login Failed'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(loginMsg);

    } catch (e) {
      _showErrorDialog(e.toString());
    }

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.transparent, // Replace with desired background color
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Positioned(
                  //   left: 30,
                  //   width: 80,
                  //   height: 200,
                  //   child: Container(
                  //     color: Colors.teal, // Example color for a part of the background
                  //   ),
                  // ),
                  // Positioned(
                  //   left: 140,
                  //   width: 80,
                  //   height: 150,
                  //   child: Container(
                  //     color: Colors.white, // Another example color
                  //   ),
                  // ),
                  // Positioned(
                  //   right: 40,
                  //   top: 40,
                  //   width: 80,
                  //   height: 150,
                  //   child: Container(
                  //     // This could be replaced with an icon or other UI element
                  //     child: Icon(Icons.access_time, size: 40, color: Colors.white),
                  //   ),
                  // ),
                  Icon(Icons.phone_android_rounded, size: 40, color: Colors.black),
                  SizedBox(height: 60,),
                  Text(
                    "Hello Again!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  // Positioned(
                  //   child: Container(
                  //     margin: EdgeInsets.only(top: 50),
                  //     child: Center(
                  //       child:
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, .2),
                          blurRadius: 20.0,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return 'Email is empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: [AutofillHints.email],
                          ),
                          Divider(color: Colors.grey.shade400),
                          TextFormField(
                            controller: _passwordController,
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return 'Password is empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                            obscureText: true,
                            autofillHints: [AutofillHints.password],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login();
                        Fluttertoast.showToast(
                            msg: "Successfully login",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 8,
                            backgroundColor: Colors.teal,
                            textColor: Colors.white,
                            fontSize: 30.0
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18,color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18,color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
