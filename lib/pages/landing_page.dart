
import 'package:chat/pages/Sign_in_page.dart';
import 'package:chat/pages/homepage.dart';

import 'package:chat/viewmodels/usermodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _usermodel = Provider.of<UserModel>(context);

    if (_usermodel.viewstate == ViewState.idle) {
      if (_usermodel.user == null) {
        return SigninPage();
      } else {
        return HomePage();
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
