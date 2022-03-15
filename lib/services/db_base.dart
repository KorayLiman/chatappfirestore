import 'package:chat/models/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DBBase {
  Future<bool> saveUser(UserP user);
  Future<UserP> readUser(String userId);
}
