import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
  FirebaseFirestore.instance.collection('groups');

  // save user data
  Future saveUserData(String email, String user) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'user': user,
      'groups': [],
      'uid': uid,
    });
  }
  // get user data
  Future getUserData(String email) async {
    QuerySnapshot querySnapshot = await userCollection.where('email', isEqualTo: email).get();
    return querySnapshot;
  }
  // get user name
  Future getUserName(String uid) async {
    QuerySnapshot querySnapshot = await userCollection.where('uid', isEqualTo: uid).get();
    return querySnapshot.docs[0]['user'];
  }
  /*// save group data
  Future saveGroupData(String name, String description, String uid) async {
    return await groupCollection.doc(uid).set({
      'name': name,
      'description': description,
      'uid': uid,
    });
  }*/
  // get group data
  Future getGroupData() async {
    return await userCollection.doc(uid).snapshots();
  }
  //create group
  Future createGroup(String username,String id, String groupname) async {
    DocumentReference documentReference = await groupCollection.add({
      'name': groupname,
      'admin': "${id}_${username}",
      'icon': '',
      'members': [],
      'gid': '',
    });
    //update group id
    await documentReference.update({
      'gid': documentReference.id,
      'members': FieldValue.arrayUnion(["${uid}_$username"])
    });

    await userCollection.doc(uid).update({
      'groups': FieldValue.arrayUnion(["${documentReference.id}_$groupname"])
    });
  }
  // add group to user

  // remove group from user
  Future removeGroupFromUser(String uid, String groupUid) async {
    return await userCollection.doc(uid).update({
      'groups': FieldValue.arrayRemove([groupUid])
    });
  }
  // add user to group
  Future addUserToGroup(String uid, String groupUid) async {
    return await groupCollection.doc(groupUid).update({
      'members': FieldValue.arrayUnion([uid])
    });
  }
  //get group members
  Future getGroupMembers(String groupUid) async {
    return await groupCollection.doc(groupUid).snapshots();
  }
  //get group name
  Future getGroupName(String groupUid) async {
    QuerySnapshot querySnapshot= await groupCollection.where('gid', isEqualTo: groupUid).get();
    return querySnapshot;
  }
  //get chat messages
  Future getChatData(String groupUid) async {
    return await groupCollection.doc(groupUid).collection('messages').orderBy('time', descending: true).snapshots();
  }
  //add chat message
  Future addChatMessage(String groupUid, String message, String username, String uid) async {
    return await groupCollection.doc(groupUid).collection('messages').add({
      'message': message,
      'username': username,
      'uid': uid,
      'time': DateTime.now().millisecondsSinceEpoch,
    });
  }
  //get groups
  Future getGroups(String text) async {
    return await groupCollection.where('name', isEqualTo: text).get();
  }
  //check if user is in group
  Future checkIfUserInGroup(String groupUid, String username) async {
    QuerySnapshot querySnapshot = await groupCollection.where('gid', isEqualTo: groupUid).get();
    return querySnapshot.docs[0]['members'].contains("${uid}_$username");
  }
  //join/exit group
  Future joinExitGroup(String groupUid, String username) async {
    QuerySnapshot querySnapshot = await groupCollection.where('gid', isEqualTo: groupUid).get();
    if(querySnapshot.docs[0]['members'].contains("${uid}_$username")){
      await groupCollection.doc(groupUid).update({
        'members': FieldValue.arrayRemove(["${uid}_$username"])
      });
      await userCollection.doc(uid).update({
        'groups': FieldValue.arrayRemove(["${groupUid}_${querySnapshot.docs[0]['name']}"])
      });
    }else{
      await groupCollection.doc(groupUid).update({
        'members': FieldValue.arrayUnion(["${uid}_$username"])
      });
      await userCollection.doc(uid).update({
        'groups': FieldValue.arrayUnion(["${groupUid}_${querySnapshot.docs[0]['name']}"])
      });
    }
  }
}