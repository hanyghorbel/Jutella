import 'package:firebase_auth/firebase_auth.dart';
import 'package:whproject/helper/helper.dart';
import 'package:whproject/service/database.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future login(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      )).user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      else {
        return e.message;
      }
    }
  }

  // register
  Future register(String email, String password, String username) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
      )).user!;
      if (user != null) {
        await DatabaseService(uid: user.uid).saveUserData(email, username);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      else {
        return e.message;
      }
    }
  }

  // sign out
  Future signOut() async {
    try {
      await HelperFunctions.saveUserId(false);
      await HelperFunctions.saveUserEmail("");
      await HelperFunctions.saveUserName("");
      await firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}