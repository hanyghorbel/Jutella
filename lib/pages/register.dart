import 'package:flutter/material.dart';
import 'package:whproject/helper/helper.dart';
import 'package:whproject/pages/homepage.dart';
import 'package:whproject/service/authentification.dart';
import 'package:whproject/widgets/widgets.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final key = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String passwordVerif = "";
  String username = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Color(0XFFF18800),
      ),
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
                  email = value;
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
                  prefixIcon: Icon(
                      Icons.lock,
                      color: Color(0XFFF18800),
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFF18800)),
                  ),
                ),
                onChanged: (value) {
                  password = value;
                },
                validator: (value) {
                  return value!.length < 6 ? "Please provide a password 6+ characters long" : null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Confirm Password",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Color(0XFFF18800),
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFF18800)),
                  ),
                ),
                onChanged: (value) {
                  passwordVerif = value;
                },
                validator: (value) {
                  return passwordVerif==password
                      ?  null
                      : "Passwords do not match";
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Username",
                  prefixIcon: Icon(
                      Icons.person,
                      color: Color(0XFFF18800),
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFF18800)),
                  ),
                ),
                onChanged: (value) {
                  username = value;
                },
                validator: (value) {
                  return value!.length > 3
                      ? null
                      : "Please provide a username 3+ characters long";
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  register();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50.0),
                  backgroundColor: Color(0XFFF18800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ), // style
                child: const Text("Register"),
              ),
            ],
            ),
        ),
        ),
      ),
    );
  }
  register() async {
    if (key.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.register(email, password, username).then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserId(true);
          await HelperFunctions.saveUserEmail(email);
          await HelperFunctions.saveUserName(username);
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
      //   isLoading = false;
      // });
      // nextScreenReplace(context, const HomePage());
    }
  } // register
}