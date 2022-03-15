import 'package:chat/models/usermodel.dart';
import 'package:chat/services/authbase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<UserP?> currentUser() async {
    try {
      User? _user = await _firebaseAuth.currentUser;
      return _userFromFirebase(_user);
    } catch (error) {
      print("current user error" + error.toString());
      return null;
    }
  }

  UserP? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserP(userId: user.uid, email: user.email??"");
  }

  @override
  Future<UserP?> signInAnonymously() async {
    try {
      UserCredential credential = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(credential.user);
    } catch (error) {
      print("signin anonymously error " + error.toString());
    }
  }

  @override
  Future<bool> singOut() async {
    try {
      await GoogleSignIn().signOut();

      await _firebaseAuth.signOut();
      return true;
    } catch (error) {
      print("signout " + error.toString());
      return false;
    }
  }

  @override
  Future<UserP?> signInwithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential crd =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return _userFromFirebase(crd.user);
  }

  @override
  Future<UserP?> createUserWithEmailandPassword(
      String? email, String? pw) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email!, password: pw!);
      return _userFromFirebase(credential.user);
    } catch (error) {
      print("signin anonymously error1 " + error.toString());
    }
  }

  @override
  Future<UserP?> signInWithEmailandPassword(String? email, String? pw) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email!, password: pw!);
      return _userFromFirebase(credential.user);
    } catch (error) {
      print("signin anonymously error " + error.toString());
    }
  }
}
