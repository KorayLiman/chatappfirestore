import 'package:cloud_firestore/cloud_firestore.dart';

class UserP {
  final String userId;
  String email;
  String? userName;
  String? profileUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? level;

  UserP({required this.userId, required this.email});

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "email": email,
      "userName": userName,
      "profileUrl": profileUrl ??
          "https://emrealtunbilek.com/wp-content/uploads/2016/10/apple-icon-72x72.png",
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      "updatedAt": updatedAt ?? FieldValue.serverTimestamp(),
      "level": level ?? 1
    };
  }

  UserP.fromMap(Map<String, dynamic> map)
      : userId = map["userId"],
        email = map["email"],
        userName = map["userName"],
        profileUrl = map["profileUrl"],
        createdAt = (map["createdAt"]as Timestamp ).toDate(),
        updatedAt = (map["updatedAt"]as Timestamp).toDate(),
        level = map["level"];

        @override
  String toString() {
    // TODO: implement toString
    
    return email;
  }
}
