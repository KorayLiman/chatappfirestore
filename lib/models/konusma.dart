import 'package:cloud_firestore/cloud_firestore.dart';

class Konusma {
  final String konusma_sahibi;
  final String kimle_konusuyor;
  final bool konusma_goruldu;
  final Timestamp? olusturulma_tarihi;
  final String? son_yollanan_mesaj;
  final Timestamp gorulme_tarihi;
  String? konusulanUserName;
  String? konusuluanUserProfileUrl;

  Konusma(
      {required this.konusma_sahibi,
this.konusulanUserName,this.konusuluanUserProfileUrl,
      required this.kimle_konusuyor,
      required this.konusma_goruldu,
      this.olusturulma_tarihi,
      this.son_yollanan_mesaj,
      required this.gorulme_tarihi});

  Map<String, dynamic> toMap() {
    return {
      "konusma_sahibi": konusma_sahibi,
      "kimle_konusuyor": kimle_konusuyor,
      "konusma_goruldu": konusma_goruldu,
      "olusturulma_tarihi": olusturulma_tarihi ?? FieldValue.serverTimestamp(),
      "son_yollanan_mesaj": son_yollanan_mesaj ?? FieldValue.serverTimestamp(),
      "gorulme_tarihi": gorulme_tarihi
    };
  }

  Konusma.fromMap(Map<String, dynamic> map)
      : konusma_sahibi = map["konusma_sahibi"],
        kimle_konusuyor = map["kimle_konusuyor"],
        konusma_goruldu = map["konusma_goruldu"],
        olusturulma_tarihi = map["olusturulma_tarihi"],
        son_yollanan_mesaj = map["son_yollanan_mesaj"],
        gorulme_tarihi = map["gorulme_tarihi"];

  @override
  String toString() {
    // TODO: implement toString
    return konusma_sahibi;
  }
}
