import 'package:chat/models/konusma.dart';
import 'package:chat/models/mesaj.dart';
import 'package:chat/models/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DBBase {
  Future<bool> saveUser(UserP user);
  Future<UserP> readUser(String userId);
  Future<bool> updateUserName(String userID, String yeniUserName);
  Future<bool> updateProfilFoto(String userId, String profilFotoUrl);
  Future<List<UserP>> getAllUsers();
  Future<List<Konusma>> getAllConversations(String userId);
  Stream<List<Mesaj>> getMessages(String currentUserId, String konusulanUserId);
  Future<bool> saveMessage(Mesaj kaydidilecekMesaj);
}
