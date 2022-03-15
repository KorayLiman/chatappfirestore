import 'dart:io';

import 'package:chat/common_widgets/platformduyarliwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformDuyarliAlertDiyalog extends PlatformDuyarliWidget {
  final String baslik;
  final String icerik;
  final String anaButonYazisi;
  final String? iptalButonYazisi;

  PlatformDuyarliAlertDiyalog(
      {required this.baslik,
      required this.icerik,
      required this.anaButonYazisi,
      this.iptalButonYazisi});

  Future<bool> goster(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => this)
        : await showDialog(
            context: context,
            builder: (context) => this,
            barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(baslik),
      content: Text(icerik),
      actions: _diyalogbutonlariniayarla(context),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(baslik),
      content: Text(icerik),
      actions: _diyalogbutonlariniayarla(context),
    );
  }

  List<Widget> _diyalogbutonlariniayarla(BuildContext context) {
    final tumbutonlar = <Widget>[];
    if (Platform.isIOS) {
      if (iptalButonYazisi != null) {
        tumbutonlar.add(CupertinoDialogAction(
          child: Text(iptalButonYazisi!),
          onPressed: () {Navigator.of(context).pop(false);},
        ));
      }
      tumbutonlar.add(CupertinoDialogAction(
        child: Text(anaButonYazisi),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ));
    } else {
      if (iptalButonYazisi != null) {
        tumbutonlar.add(TextButton(
          child: Text(iptalButonYazisi!),
          onPressed: () {Navigator.of(context).pop(false);},
        ));
      }
      tumbutonlar.add(TextButton(
        child: Text(anaButonYazisi),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ));
    }
    return tumbutonlar;
  }
}
