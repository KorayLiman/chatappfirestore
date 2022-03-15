import 'package:chat/models/usermodel.dart';

abstract class DBBase {
  Future<bool> saveUser(UserP user);
}
