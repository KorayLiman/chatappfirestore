import 'package:chat/locator.dart';
import 'package:chat/models/usermodel.dart';
import 'package:chat/services/authbase.dart';
import 'package:chat/services/fakeauthservice.dart';
import 'package:chat/services/firebaseauthservice.dart';
import 'package:chat/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FireStoreDBService _fireStoreDBService = locator<FireStoreDBService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserP?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      return await _firebaseAuthService.currentUser();
    }
  }

  @override
  Future<UserP?> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> singOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.singOut();
    } else {
      return await _firebaseAuthService.singOut();
    }
  }

  @override
  Future<UserP?> signInwithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInwithGoogle();
    } else {
      UserP? user =
          await _firebaseAuthService.signInwithGoogle();
      bool result = await _fireStoreDBService.saveUser(user!);
      if (result) {
        return user;
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserP?> createUserWithEmailandPassword(
      String? email, String? pw) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createUserWithEmailandPassword(email, pw);
    } else {
      UserP? user =
          await _firebaseAuthService.createUserWithEmailandPassword(email, pw);
      bool result = await _fireStoreDBService.saveUser(user!);
      if (result) {
        return user;
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserP?> signInWithEmailandPassword(String? email, String? pw) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmailandPassword(email, pw);
    } else {
      return await _firebaseAuthService.signInWithEmailandPassword(email, pw);
    }
  }
}
