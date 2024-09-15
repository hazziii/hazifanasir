import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:translation/pages/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Registration Failed'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Show a toast message after successful registration
      Fluttertoast.showToast(
        msg: "Successfully signed up",  // Toast message content
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 8,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 30.0,
      );
      Navigator.of(context).pop(); // Go back to the login page
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.transparent, // Background color
              ),
              child: const Column(
                children: [
                  SizedBox(height: 60,),
                  Icon(Icons.phone_android_rounded, size: 50, color: Colors.black),
                  SizedBox(height: 60,),
                  Text(
                    "HELLO THERE",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.normal,

                    ),
                  ),
                  Text(
                    "Register below with your details",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.normal,

                    ),
                  ),

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
                              labelText: "Email",
                              hintText: "Enter your email",
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
                              // Check if the password contains at least one uppercase letter
                              if (!RegExp(r'[A-Z]').hasMatch(text)) {
                                return 'Password must contain at least one uppercase letter';
                              }
                              // Check if the password contains at least one digit
                              if (!RegExp(r'[0-9]').hasMatch(text)) {
                                return 'Password must contain at least one number';
                              }
                              // Check if the password contains at least one special character
                              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text)) {
                                return 'Password must contain at least one special character';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Password",
                              hintText: "Enter your password",
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
                        _register();
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
                      'Sign Up',
                      style: TextStyle(fontSize: 18,color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Go back to login page
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Already a member?\n      Login Now',
                      style: TextStyle(fontSize: 18),
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
