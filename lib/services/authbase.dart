import 'package:chat/models/usermodel.dart';

abstract class AuthBase {
  Future<UserP?> currentUser();
  Future<UserP?> signInAnonymously();
  Future<bool> singOut();
  Future<UserP?> signInwithGoogle();
  Future<UserP?> signInWithEmailandPassword(String? email, String?pw);
  Future<UserP?> createUserWithEmailandPassword(String? email, String?pw);
}
