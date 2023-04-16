import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whproject/helper/helper.dart';
import 'package:whproject/pages/chatroom.dart';
import 'package:whproject/pages/loginpage.dart';
import 'package:whproject/pages/profilepage.dart';
import 'package:whproject/pages/searchpage.dart';
import 'package:whproject/pages/settingspasge.dart';
import 'package:whproject/service/authentification.dart';
import 'package:whproject/service/database.dart';
import 'package:whproject/widgets/widgets.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String email = "";
  String username = "";
  AuthService authService = AuthService();
  Stream? groupStream;
  String groupName = "";
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }
  getUserInfo() async {
    await HelperFunctions.getUserName().then((value) {
      setState(() {
        username = value!;
      });
    });
    await HelperFunctions.getUserEmail().then((value) {
      setState(() {
        email = value!;
      });
    });
    // gettting the group stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getGroupData().then((snapshot) {
      setState(() {
        groupStream = snapshot;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(context, SearchPage());
            },
            icon: const Icon(Icons.search),
          ),
        ],
        centerTitle: true,
        backgroundColor: Color(0XFFF18800),
        title: const Text("Ju tell us about it", style: TextStyle(color: Colors.white30)),

      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewGroup(context);
        },
        backgroundColor: Color(0XFFF18800),
        child: const Icon(Icons.add),
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
              "$username",
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
                  email: email,
                  username: username,
                ));
              },
            ),
            ListTile(
              title: const Text("Tellers"),
              leading: const Icon(Icons.groups),
              onTap: () {},
              selected: true,
              selectedColor : Color(0XFFF18800),
            ),
            /*ListTile(
              title: const Text("Settings"),
              leading: const Icon(Icons.settings),
              onTap: () {
                nextScreen(context, SettingsPage(
                  email: email,
                  username: username,
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
  groupList() {
    return StreamBuilder(
      stream: groupStream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  if (snapshot.data['groups'].length ==0 || snapshot.data['groups'] == null){
                    return Container(
                      child: const Center(
                        child: Text("No groups yet"),
                      ),
                    );
                  }
                  else{
                  return groupTile(
                    groupName: getName(snapshot.data["groups"][index]),
                    groupId: getId(snapshot.data["groups"][index]),
                  );}
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
  groupTile({required String groupName, required String groupId}) {
    return GestureDetector(
      onTap: () {
        nextScreen(context, ChatRoom(
          groupId: groupId,
          groupName: groupName,
          userName: username,
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0XFFF18800),
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
              ),
              child: Text(
                "${groupName.substring(0, 1).toUpperCase()}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              groupName,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
  createNewGroup(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create new group"),
          content: TextField(
            onChanged: (value) {
              groupName = value;
            },
            decoration: const InputDecoration(
              hintText: "Group name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Color(0XFFF18800))),
            ),
            TextButton(
              onPressed: () async{
                if (groupName.isNotEmpty) {
                  await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(username,FirebaseAuth.instance.currentUser!.uid, groupName);
                  Navigator.pop(context);
                  showSnackBar(context, "Group created successfully");
                }
              },
              child: const Text("Create", style: TextStyle(color: Color(0XFFF18800))),
            ),
          ],
        );
      },
    );
  }
  String getName(String group) {
    return group.substring(group.indexOf("_")+1);
  }
  String getId(String group) {
    return group.split("_")[0];
  }
}