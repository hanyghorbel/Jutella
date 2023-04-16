import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whproject/helper/helper.dart';
import 'package:whproject/pages/homepage.dart';
import 'package:whproject/pages/register.dart';
import 'package:whproject/service/authentification.dart';
import 'package:whproject/service/database.dart';
import 'package:whproject/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final key = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: key,
            child: Column(
              children: [
                  const SizedBox(height: 20.0),
                  const Text(
                    "Jutella",
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFFF18800),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Enjoy your day and tell about it!",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Image.asset("assets/template.png"),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0XFFF18800),
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFFF18800)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    validator: (value) {
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value!)
                          ? null
                          : "Please enter a valid email";
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock, color: Color(0XFFF18800)),

                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0XFFF18800)),
                      ),
                    ),
                    validator: (value) {
                      return value!.length < 6
                          ? "Please provide password 6+ characters"
                          : null ;
                    },
                    onChanged: (value) {
                        password = value;
                    },

                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50.0),
                      primary: Color(0XFFF18800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ), // style
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          nextScreen(context, const Register());
                        },
                        child: const Text("Register"),
                      ),
                    ],
                  ),
                ],
            ),
          ),

        )
      )
    );
  }
login() async {
  if (key.currentState!.validate()) {
    setState(() {
     _isLoading = true;
    });
    await authService.login(email, password).then((value) async {
      if (value == true) {
        QuerySnapshot querySnapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserData(email);
        await HelperFunctions.saveUserId(true);
        await HelperFunctions.saveUserEmail(email);
        await HelperFunctions.saveUserName(querySnapshot.docs[0].get("user"));

        nextScreenReplace(context, const HomePage());
      }
      else {
        showSnackBar(context, value);
        setState(() {
          _isLoading = false;
        });
        // nextScreenReplace(context, const HomePage());
      }
    });
    // await Future.delayed(const Duration(seconds: 3));
    // setState(() {
    //   _isLoading = false;
    // });
    // nextScreenReplace(context, const HomePage());
  }
  }
}