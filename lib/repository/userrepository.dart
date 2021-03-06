import 'dart:io';
import 'package:timeago/timeago.dart' as timeago;
import 'package:chat/locator.dart';
import 'package:chat/models/konusma.dart';
import 'package:chat/models/mesaj.dart';
import 'package:chat/models/usermodel.dart';
import 'package:chat/services/authbase.dart';
import 'package:chat/services/fakeauthservice.dart';
import 'package:chat/services/firebase_storage_service.dart';
import 'package:chat/services/firebaseauthservice.dart';
import 'package:chat/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FireStoreDBService _fireStoreDBService = locator<FireStoreDBService>();
  FirebaseStorageService _fireBaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;
  List<UserP> allUserList = [];
  @override
  Future<UserP?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      UserP? user = await _firebaseAuthService.currentUser();
      return await _fireStoreDBService.readUser(user!.userId);
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
      UserP? user = await _firebaseAuthService.signInwithGoogle();
      bool result = await _fireStoreDBService.saveUser(user!);
      if (result) {
        return await _fireStoreDBService.readUser(user.userId);
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
        return await _fireStoreDBService.readUser(user.userId);
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
      UserP? user =
          await _firebaseAuthService.signInWithEmailandPassword(email, pw);
      return await _fireStoreDBService.readUser(user!.userId);
    }
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _fireStoreDBService.updateUserName(userID, yeniUserName);
    }
  }

  Future<String> uploadFile(String userId, String fileType, File? image) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya indirme linki";
    } else {
      var profilphotourl =
          await _fireBaseStorageService.uploadFile(userId, fileType, image!);
      await _fireStoreDBService.updateProfilFoto(userId, profilphotourl);
      return profilphotourl;
    }
  }

  Future<List<UserP>> getAllUsers() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      allUserList = await _fireStoreDBService.getAllUsers();
      return allUserList;
    }
  }

  Stream<List<Mesaj>> getMessages(
      String currentUserId, String sohbetedilenuserId) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _fireStoreDBService.getMessages(currentUserId, sohbetedilenuserId);
    }
  }

  Future<bool> saveMessage(Mesaj kaydidilecekMesaj) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _fireStoreDBService.saveMessage(kaydidilecekMesaj);
    }
  }

  Future<List<Konusma>> getAllConversations(String userId) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _zaman = await _fireStoreDBService.saatiGoster(userId);
      var konusmaListesi =
          await _fireStoreDBService.getAllConversations(userId);
      for (var oankiKonusma in konusmaListesi) {
        var userListesindekiKullanici =
            listedeUserBul(oankiKonusma.kimle_konusuyor);
        if (userListesindekiKullanici != null) {
          oankiKonusma.konusulanUserName = userListesindekiKullanici!.userName;
          oankiKonusma.konusuluanUserProfileUrl =
              userListesindekiKullanici.profileUrl;
          oankiKonusma.sonOkunmaZamani = _zaman;
          timeago.setLocaleMessages("tr", timeago.TrMessages());
          var _duration =
              _zaman.difference(oankiKonusma.olusturulma_tarihi!.toDate());
          oankiKonusma.aradakiFark = timeago.format(_zaman.subtract(_duration),locale: "tr");
        } else {
          print("Aran??lan user daha ??nceden veri taban??ndan getirilmemi??tir.");
          var _veritabanindanokunanuser =
              await _fireStoreDBService.readUser(oankiKonusma.kimle_konusuyor);
          oankiKonusma.konusulanUserName = _veritabanindanokunanuser.userName;
          oankiKonusma.konusuluanUserProfileUrl =
              _veritabanindanokunanuser.profileUrl;
          oankiKonusma.sonOkunmaZamani = _zaman;
           timeago.setLocaleMessages("tr", timeago.TrMessages());
          var _duration =
              _zaman.difference(oankiKonusma.olusturulma_tarihi!.toDate());
          oankiKonusma.aradakiFark = timeago.format(_zaman.subtract(_duration),locale: "tr");
        }
      }
      return konusmaListesi;
    }
  }

  UserP? listedeUserBul(String userID) {
    for (int i = 0; i < allUserList.length; i++) {
      if (allUserList[i].userName == userID) {
        return allUserList[i];
      }
    }
    return null;
  }
}
