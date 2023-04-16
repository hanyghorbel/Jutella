import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whproject/pages/chatroom.dart';
import 'package:whproject/service/database.dart';
import 'package:whproject/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  Stream? searchResultStream;
  QuerySnapshot? searchResultSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  bool isMember = false;
  @override
  void initState() {
    super.initState();
    getUserName();
  }
  getUserName() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserName(FirebaseAuth.instance.currentUser!.uid).then((value) {
      setState(() {
        userName = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0XFFF18800),
          title: const Text("Search", style: TextStyle(color: Colors.white30)),
        ),
        body: Column(
          children: [
            Container(
              color: Color(0XFFF18800),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search group...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (searchController.text.isNotEmpty) {
                        setState(() {
                          _isLoading = true;
                        });
                        DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getGroups(searchController.text).then((snapshot) {
                          setState(() {
                            searchResultSnapshot = snapshot;
                            _isLoading = false;
                            hasUserSearched = true;
                          });
                        });
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0x36FFFFFF),
                            Color(0x0FFFFFFF),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      // padding: const EdgeInsets.all(12),
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : groupList(),
          ],
        )
    );
  }
  Widget groupList() {
    return hasUserSearched
        ? searchResultSnapshot!.docs.length != 0
        ? ListView.builder(
        itemCount: searchResultSnapshot!.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return groupTile(
            userName: userName,
            groupId: searchResultSnapshot!.docs[index]["gid"],
            groupName: searchResultSnapshot!.docs[index]["name"],
            groupAdmin: searchResultSnapshot!.docs[index]["admin"],
          );
        })
        : const Center(child: Text("No groups found", style: TextStyle(color: Colors.black54, fontSize: 16)))
        : const Center(child: Text("Search for groups", style: TextStyle(color: Colors.black54, fontSize: 16)));
  }
  checkIfUserInGroup(String groupId) async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).checkIfUserInGroup(groupId, userName).then((value) {
      setState(() {
        isMember = value;
      });
    });
  }
  Widget groupTile({required String userName, required String groupId, required String groupName, required String groupAdmin}) {
    checkIfUserInGroup(groupId);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            height: 40.0,
            width: 40.0,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0XFFFB8C00),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(groupName, style: const TextStyle(color: Colors.black, fontSize: 16)),
              Text(groupAdmin.substring(groupAdmin.indexOf('_')+1), style: const TextStyle(color: Colors.black54, fontSize: 12)),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () async{
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).joinExitGroup(groupId, userName);
              if (!isMember) {
                setState(() {
                  isMember = !isMember;
                });
                showSnackBar(context, "You have left the group");
              }
              else {
                setState(() {
                  isMember = !isMember;
                });
                showSnackBar(context, "You have joined the group");
              }

            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent ,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: isMember ? Text("Leave teller", style: const TextStyle(color: Colors.white, fontSize: 12)) :
              Text("Join teller", style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}