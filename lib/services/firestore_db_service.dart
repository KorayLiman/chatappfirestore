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
}
