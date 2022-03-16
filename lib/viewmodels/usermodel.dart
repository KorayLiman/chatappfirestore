import 'dart:io';

import 'package:chat/locator.dart';
import 'package:chat/models/mesaj.dart';
import 'package:chat/models/usermodel.dart';
import 'package:chat/repository/userrepository.dart';
import 'package:chat/services/authbase.dart';
import 'package:flutter/material.dart';

import '../models/konusma.dart';

enum ViewState { idle, busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _viewState = ViewState.idle;
  UserRepository _userRepository = locator<UserRepository>();
  UserP? _userP;
  String? emailerrormessage;
  String? passworderrormessage;

  ViewState get viewstate => _viewState;

  UserP? get user => _userP;

  set viewstate(ViewState value) {
    _viewState = value;
    notifyListeners();
  }

  UserModel() {
    currentUser();
  }
  @override
  Future<UserP?> currentUser() async {
    try {
      viewstate = ViewState.busy;
      _userP = await _userRepository.currentUser();
      return _userP;
    } catch (error) {
      print(error);
      return null;
    } finally {
      viewstate = ViewState.idle;
    }
  }

  @override
  Future<UserP?> signInAnonymously() async {
    try {
      viewstate = ViewState.busy;
      _userP = await _userRepository.signInAnonymously();
      return _userP;
    } catch (error) {
      print(error);
      return null;
    } finally {
      viewstate = ViewState.idle;
    }
  }

  @override
  Future<bool> singOut() async {
    try {
      viewstate = ViewState.busy;
      bool result = await _userRepository.singOut();
      _userP = null;
      return result;
    } catch (error) {
      print(error);
      return false;
    } finally {
      viewstate = ViewState.idle;
    }
  }

  @override
  Future<UserP?> signInwithGoogle() async {
    try {
      viewstate = ViewState.busy;
      _userP = await _userRepository.signInwithGoogle();
      return _userP;
    } catch (error) {
      print(error);
      return null;
    } finally {
      viewstate = ViewState.idle;
    }
  }

  @override
  Future<UserP?> createUserWithEmailandPassword(
      String? email, String? pw) async {
    if (_emailpwControl(email!, pw!)) {
      try {
        viewstate = ViewState.busy;
        _userP =
            await _userRepository.createUserWithEmailandPassword(email, pw);
        return _userP;
      } finally {
        viewstate = ViewState.idle;
      }
    } else {
      return null;
    }
  }

  @override
  Future<UserP?> signInWithEmailandPassword(String? email, String? pw) async {
    try {
      if (_emailpwControl(email!, pw!)) {
        viewstate = ViewState.busy;
        _userP = await _userRepository.signInWithEmailandPassword(email, pw);
        return _userP;
      } else {
        return null;
      }
    } finally {
      viewstate = ViewState.idle;
    }
  }

  bool _emailpwControl(String email, String pw) {
    var result = true;
    if (pw.length < 6) {
      passworderrormessage = "Şifre En az 6 karakter olmalı";
      result = false;
    } else {
      passworderrormessage = null;
    }
    if (!email.contains("@")) {
      emailerrormessage = "Email hatalı";
      result = false;
    } else {
      emailerrormessage = null;
    }
    return result;
  }

  Future<bool> updateUserName(String userId, String yeniUserName) async {
    var sonuc = await _userRepository.updateUserName(userId, yeniUserName);
    if (sonuc) {
      _userP!.userName = yeniUserName;
    }

    return sonuc;
  }

  Future<String> uploadFile(String userId, String fileType, File? image) async {
    var link = await _userRepository.uploadFile(userId, fileType, image);
    return link;
  }

  Future<List<UserP>> getAllUsers() async {
    var allUsers = await _userRepository.getAllUsers();
    return allUsers;
  }

  Stream<List<Mesaj>> getMessages(
      String currentUserId, String sohbetedilenuserId) {
    return _userRepository.getMessages(currentUserId, sohbetedilenuserId);
  }

  Future<bool> saveMessage(Mesaj kaydidilecekMesaj) async{
    return await _userRepository.saveMessage(kaydidilecekMesaj);
  }

  Future<List<Konusma>> getAllConversations(String userId)async {
    return await _userRepository.getAllConversations(userId);
  }
}
