import 'package:chat/models/usermodel.dart';
import 'package:chat/services/authbase.dart';


class FakeAuthService implements AuthBase {
  String userId = "dfgdgfdgdgdg";
  @override
  Future<UserP?> currentUser() async {
    return await Future.value(UserP(userId: userId,email: "dqwd@go.com"));
  }

  @override
  Future<UserP?> signInAnonymously() async {
    return await Future.delayed(const Duration(seconds: 2),() => UserP(userId: userId, email: ""),);
  }

  @override
  Future<bool> singOut() {
    return Future.value(true);
  }

  @override
  Future<UserP?> signInwithGoogle() async{
    
    return await Future.delayed(const Duration(seconds: 2),() => UserP(userId: "google_user_id:1232131232", email: "google email"),);
  }

  @override
  Future<UserP?> createUserWithEmailandPassword(String? email, String? pw) async{
    return await Future.delayed(const Duration(seconds: 2),() => UserP(userId: "created user id", email: "qcwqd@h.com"),);
  }

  @override
  Future<UserP?> signInWithEmailandPassword(String? email, String? pw)async {
    return await Future.delayed(const Duration(seconds: 2),() => UserP(userId: "signed in user id", email: ""),);
  }
}
