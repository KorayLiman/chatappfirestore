import 'package:chat/models/usermodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/usermodel.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
    
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    final _usermodel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () => _cikisYap(context),
              child: const Text(
                "Çıkış yap",
                style: TextStyle(color: Colors.white),
              ))
        ],
        title: const Text("Ana sayfa"),
      ),
      body: Center(
        child: Text("Hoşgeldiniz ${_usermodel.user!.userId}"),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _usermodel = Provider.of<UserModel>(context, listen: false);
    bool result = await _usermodel.singOut();

    return result;
  }
}
