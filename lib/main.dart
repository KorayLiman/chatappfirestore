import 'package:chat/firebase_options.dart';
import 'package:chat/locator.dart';

import 'package:chat/pages/landing_page.dart';

import 'package:chat/viewmodels/usermodel.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return UserModel();
      },
      child: MaterialApp(
        title: "Chat App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        home: LandingPage()
      ),
    );
  }
}
