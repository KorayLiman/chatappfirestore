import 'package:cloud_firestore/cloud_firestore.dart';

class Mesaj {
  final String kimden;
  final String kime;
  final bool bendenmi;
  final String mesaj;
  final Timestamp? date;

  Mesaj(
      {required this.kimden,
      required this.kime,
      required this.bendenmi,
      required this.mesaj,
      this.date});

  Map<String, dynamic> toMap() {
    return {
      "kimden": kimden,
      "kime": kime,
      "bendenmi": bendenmi,
      "mesaj": mesaj,
      "date": date??FieldValue.serverTimestamp()
    };
  }

  Mesaj.fromMap(Map<String, dynamic> map)
      : kimden = map["kimden"],
        kime = map["kime"],
        bendenmi = map["bendenmi"],
        mesaj = map["mesaj"],
        date = (map["date"]);
  @override
  String toString() {
    // TODO: implement toString
    return mesaj + kimden + kime;
  }
}
