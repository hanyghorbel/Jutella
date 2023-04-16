import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:whproject/helper/helper.dart';
import 'package:whproject/pages/homepage.dart';
import 'package:whproject/pages/loginpage.dart';
import 'package:whproject/pages/register.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCgTNVWsnUXuzdDRYOELJDZSB2Lv7KVcik",
          projectId: "jutella-d4f87",
          messagingSenderId: "725789420551",
          appId: "1:725789420551:web:e0983640b1f5d247bb0ea2")
    );
  }
  else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool _isUserLoggedIn = false;
  @override
  void initState() {
    super.initState();
    getuserstatus();
  }
  getuserstatus() async {
    await HelperFunctions.userstatus().then((value) {
      if(value == null) {
        setState(() {
          _isUserLoggedIn = false;
        });
      }
      else {
        setState(() {
          _isUserLoggedIn = value;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _isUserLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}