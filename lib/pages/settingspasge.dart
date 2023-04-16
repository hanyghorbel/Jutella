import 'package:flutter/material.dart';
import 'package:whproject/pages/homepage.dart';
import 'package:whproject/pages/loginpage.dart';
import 'package:whproject/pages/profilepage.dart';
import 'package:whproject/service/authentification.dart';
import 'package:whproject/widgets/widgets.dart';

class SettingsPage extends StatefulWidget {
  String email="";
  String username="";
  SettingsPage({Key? key, required this.username, required this.email}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Settings", style: TextStyle(color: Colors.grey)),
      ),
      body: Center(
        child: Text("Settings Page"),
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
              title: const Text("Profile"),
              leading: const Icon(Icons.person),
              onTap: () {
                nextScreen(context, ProfilePage(
                  email: widget.email,
                  username: widget.username,
                ));
              },
            ),
            ListTile(
              title: const Text("Tellers"),
              leading: const Icon(Icons.groups),
              onTap: () {
                nextScreen(context, const HomePage());
              },
            ),
            ListTile(
              selected: true,
              title: const Text("Settings"),
              leading: const Icon(Icons.settings),
              onTap: () {},
            ),
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