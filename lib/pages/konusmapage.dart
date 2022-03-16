import 'package:chat/models/mesaj.dart';
import 'package:chat/models/usermodel.dart';
import 'package:chat/viewmodels/usermodel.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class KonusmaPage extends StatefulWidget {
  const KonusmaPage(
      {Key? key, required this.currentUser, required this.sohbetedilenuser})
      : super(key: key);

  final UserP currentUser;
  final UserP sohbetedilenuser;

  @override
  State<KonusmaPage> createState() => _KonusmaPageState();
}

class _KonusmaPageState extends State<KonusmaPage> {
  var _mesajController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final _usermodel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sohbet"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<List<Mesaj>>(
              stream: _usermodel.getMessages(
                  widget.currentUser.userId, widget.sohbetedilenuser.userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<Mesaj> TumMesajlar = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return _KonusmaPageBalonuOlustur(TumMesajlar[index]);
                    },
                  );
                }
              },
            )),
            Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _mesajController,
                    cursorColor: Colors.blueGrey,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Mesajınızı yazın",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none)),
                  )),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.navigation,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (_mesajController.text.trim().length > 0) {
                          Mesaj _kaydidilecekMesaj = Mesaj(
                            kimden: widget.currentUser.userId,
                            kime: widget.sohbetedilenuser.userId,
                            bendenmi: true,
                            mesaj: _mesajController.text,
                          );
                          var sonuc =
                              await _usermodel.saveMessage(_kaydidilecekMesaj);
                          if (sonuc) {
                            _mesajController.clear();
                            _scrollController.animateTo(0.0,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeOut);
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _KonusmaPageBalonuOlustur(Mesaj oankimesaj) {
    var saatDakikeDegeri = "";
    try {
      saatDakikeDegeri = _saatDakikaGoster(oankimesaj.date ?? Timestamp(1, 1));
    } catch (error) {}
    Color _gelenMesajRenk = Colors.blue;
    Color _gidenMesajRenk = Theme.of(context).primaryColor;
    var _benimMesajimMi = oankimesaj.bendenmi;
    if (_benimMesajimMi) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(oankimesaj.mesaj),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _gidenMesajRenk),
                  ),
                ),
                Text(saatDakikeDegeri)
              ],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      NetworkImage(widget.sohbetedilenuser.profileUrl!),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(oankimesaj.mesaj),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _gelenMesajRenk),
                  ),
                ),
                Text(saatDakikeDegeri)
              ],
            )
          ],
        ),
      );
    }
  }

  String _saatDakikaGoster(Timestamp? date) {
    var _formatter = DateFormat.Hm();

    var _formatlanmisTarih = _formatter.format(date!.toDate());
    return _formatlanmisTarih;
  }
}
