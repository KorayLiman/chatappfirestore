import 'package:chat/models/konusma.dart';
import 'package:chat/models/mesaj.dart';
import 'package:chat/models/usermodel.dart';
import 'package:chat/services/db_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreDBService implements DBBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserP user) async {
    await _firestore.collection("users").doc(user.userId).set(user.toMap());

    DocumentSnapshot snpshot =
        await _firestore.collection("users").doc(user.userId).get();

    Map<String, dynamic> readUserInformation =
        snpshot.data() as Map<String, dynamic>;
    UserP readUserObject = UserP.fromMap(readUserInformation);
    print(readUserObject.email);

    return true;
  }

  @override
  Future<UserP> readUser(String userId) async {
    DocumentSnapshot _okunanUser =
        await _firestore.collection("users").doc(userId).get();
    Map<String, dynamic> _okunanuserbilgileriMap =
        _okunanUser.data() as Map<String, dynamic>;
    UserP okunanusernesnesi = UserP.fromMap(_okunanuserbilgileriMap);
    print("Okunan user nesnesi: " + okunanusernesnesi.toString());
    return okunanusernesnesi;
  }

  @override
  Future<bool> updateUserName(String userID, String yeniUserName) async {
    QuerySnapshot users = await _firestore
        .collection("users")
        .where("userName", isEqualTo: yeniUserName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firestore
          .collection("users")
          .doc(userID)
          .update({"userName": yeniUserName});
      return true;
    }
  }

  Future<bool> updateProfilFoto(String userID, String profilphotourl) async {
    await _firestore
        .collection("users")
        .doc(userID)
        .update({"profileUrl": profilphotourl});
    return true;
  }

  @override
  Future<List<UserP>> getAllUsers() async {
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    List<UserP> allUsers = [];
    for (var user in querySnapshot.docs) {
      UserP _user = UserP.fromMap(user.data() as Map<String, dynamic>);
      allUsers.add(_user);
    }

    // allUsers = querySnapshot.docs
    //     .map((e) => UserP.fromMap(e.data() as Map<String, dynamic>))
    //     .toList();

    return allUsers;
  }

  @override
  Stream<List<Mesaj>> getMessages(
      String currentUserId, String Sohbetedilenuserid) {
    var snpshot = _firestore
        .collection("konusmalar")
        .doc(currentUserId + "--" + Sohbetedilenuserid)
        .collection("mesajlar")
        .orderBy("date", descending: true)
        .snapshots();
    return snpshot.map(
        (event) => event.docs.map((e) => Mesaj.fromMap(e.data())).toList());
  }

  Future<bool> saveMessage(Mesaj kaydidilecekMesaj) async {
    var _mesajId = _firestore.collection("konusmalar").doc().id;
    var _myDocumentId =
        kaydidilecekMesaj.kimden + "--" + kaydidilecekMesaj.kime;
    var _receiverDocumentId =
        kaydidilecekMesaj.kime + "--" + kaydidilecekMesaj.kimden;
    var _kaydedilecekMesajMapYapisi = kaydidilecekMesaj.toMap();
    await _firestore
        .collection("konusmalar")
        .doc(_myDocumentId)
        .collection("mesajlar")
        .doc(_mesajId)
        .set(_kaydedilecekMesajMapYapisi);
    _kaydedilecekMesajMapYapisi.update("bendenmi", (value) => false);
    await _firestore.collection("konusmalar").doc(_myDocumentId).set({
      "konusma_sahibi": kaydidilecekMesaj.kimden,
      "kimle_konusuyor": kaydidilecekMesaj.kime,
      "son_yollanan_mesaj": kaydidilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
      "gorulme_tarihi": FieldValue.serverTimestamp()
    });
    await _firestore
        .collection("konusmalar")
        .doc(_receiverDocumentId)
        .collection("mesajlar")
        .doc(_mesajId)
        .set(_kaydedilecekMesajMapYapisi);
    await _firestore.collection("konusmalar").doc(_receiverDocumentId).set({
      "konusma_sahibi": kaydidilecekMesaj.kime,
      "kimle_konusuyor": kaydidilecekMesaj.kimden,
      "son_yollanan_mesaj": kaydidilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
      "gorulme_tarihi": FieldValue.serverTimestamp()
    });

    return true;
  }

  @override
  Future<List<Konusma>> getAllConversations(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: userId)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();
    List<Konusma> tumKonusmalar = [];

    for (var konusma in querySnapshot.docs) {
      Konusma kon = Konusma.fromMap(konusma.data() as Map<String, dynamic>);
      tumKonusmalar.add(kon);
    }

    return tumKonusmalar;
  }

  @override
  Future<DateTime> saatiGoster(String userId) async {
    await _firestore
        .collection("server")
        .doc(userId)
        .set({"saat": FieldValue.serverTimestamp()});
    var okunanMap = await _firestore.collection("server").doc(userId).get();
    Timestamp okunanTarih = okunanMap.data()!["saat"];
    return okunanTarih.toDate();
  }
}
