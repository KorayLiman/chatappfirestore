import 'package:chat/viewmodels/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          TextButton(
              onPressed: ()=>_cikisYap(context) ,
              child: const Text(
                "Exit",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Center(
        child: const Text("Profile Page"),
      ),
    );
  }


    Future<bool> _cikisYap(BuildContext context) async {
    final _usermodel = Provider.of<UserModel>(context, listen: false);
    bool result = await _usermodel.singOut();

    return result;
  }
}


