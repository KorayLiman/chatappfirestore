import 'package:chat/common_widgets/custombottomnavi.dart';
import 'package:chat/common_widgets/tabitems.dart';
import 'package:chat/models/usermodel.dart';
import 'package:chat/pages/Profilepage.dart';
import 'package:chat/pages/userspage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/usermodel.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItems _currentTab = TabItems.Users;

  Map<TabItems, Widget> allPages() {
    return {TabItems.Users: UsersPage(), TabItems.Profile: ProfilePage()};
  }

  @override
  Widget build(BuildContext context) {
    final _usermodel = Provider.of<UserModel>(context);
    return Container(
        child: MyCustomButtomNavi(
      PageCreator: allPages(),
      currentTab: _currentTab,
      onSelectedTab: (seletedtab) {
        setState(() {
          _currentTab = seletedtab;
        });
        print("selectedtab" + seletedtab.index.toString());
      },
    ));
  }
}


/**
 *  Future<bool> _cikisYap(BuildContext context) async {
    final _usermodel = Provider.of<UserModel>(context, listen: false);
    bool result = await _usermodel.singOut();

    return result;
  }
 */