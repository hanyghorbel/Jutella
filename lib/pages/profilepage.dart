import 'package:flutter/material.dart';
import 'package:whproject/pages/homepage.dart';
import 'package:whproject/pages/loginpage.dart';
import 'package:whproject/pages/settingspasge.dart';
import 'package:whproject/service/authentification.dart';
import 'package:whproject/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  String email="";
  String username="";
  ProfilePage({Key? key,required this.email,required this.username}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

  class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0XFFF18800),
          centerTitle: true,
          title: const Text("Profile", style: TextStyle(color: Colors.white30)),
        ),
        body: Container(
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Icon(
                Icons.account_circle,
                size: 200.0,
                color: Colors.orange[400],
              ),
              const SizedBox(height: 15.0),
              Text(
                widget.username,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 15.0),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Icon(
                Icons.account_circle,
                size: 200.0,
                color: Colors.orange[400],
              ),
              const SizedBox(height: 15.0),
              Text(
                widget.username,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
              ListTile(
                selected: true,
                selectedColor: Color(0XFFF18800),
                title: const Text("Profile"),
                leading: const Icon(Icons.person),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Tellers"),
                leading: const Icon(Icons.groups),
                onTap: () {
                  nextScreen(context, const HomePage());
                },
              ),
              /*ListTile(
                title: const Text("Settings"),
                leading: const Icon(Icons.settings),
                onTap: () {
                  nextScreen(context,SettingsPage(
                    email: widget.email,
                    username: widget.username,
                  ));
                },
              ),*/
              ListTile(
                title: const Text("Log out"),
                leading: const Icon(Icons.logout),
                onTap: () {
                  authService.signOut();
                  nextScreen(context, const LoginPage());
                },
              ),
            ],
          ),
        ),
      );
    }
  }