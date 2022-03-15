import 'package:chat/common_widgets/socialloginbuttons.dart';

import 'package:chat/models/usermodel.dart';
import 'package:chat/pages/emailpwlogin.dart';

import 'package:chat/viewmodels/usermodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatelessWidget {
  SigninPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Chat app"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Oturum aç",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(
              height: 10,
            ),
            SocilLoginButton(
                text: "Google ile giriş yap",
                textColor: Colors.black,
                color: Colors.white,
                buttonIcon: Image.asset("images/google-logo.png"),
                onPressed: () => googlesignin(context)),
            SocilLoginButton(
                text: "Facebook ile giriş yap",
                color: Color(0xFF334D92),
                edgeRadius: 12,
                buttonIcon: Image.asset("images/facebook-logo.png"),
                onPressed: () {}),
            SocilLoginButton(
                text: "Email ve şifre ile giriş yap",
                color: Colors.purple,
                edgeRadius: 12,
                buttonIcon: Icon(Icons.email),
                onPressed: () => EmailPwLogin(context)),
            SocilLoginButton(
                text: "Anonim",
                color: Colors.green,
                edgeRadius: 12,
                buttonIcon: Icon(Icons.supervised_user_circle),
                onPressed: () => _AnonymousLogin(context))
          ],
        ),
      ),
    );
  }

  void EmailPwLogin(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => EmailPwLoginPage(),
        ));
  }

  void _AnonymousLogin(BuildContext context) async {
    final _usermodel = Provider.of<UserModel>(context, listen: false);
    UserP? userP = await _usermodel.signInAnonymously();

    print(userP!.userId);
  }

  void googlesignin(BuildContext context) async {
    final _usermodel = Provider.of<UserModel>(context, listen: false);
    UserP? userP = await _usermodel.signInwithGoogle();

    print(userP!.userId);
  }
}
