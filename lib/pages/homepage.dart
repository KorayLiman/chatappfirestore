import 'package:chat/common_widgets/custombottomnavi.dart';
import 'package:chat/common_widgets/tabitems.dart';
import 'package:chat/models/usermodel.dart';
import 'package:chat/pages/Mychatspage.dart';
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
    return {TabItems.Users: UsersPage(), TabItems.MyChats:MyChats(),TabItems.Profile: ProfilePage()};
  }

  Map<TabItems, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItems.Users: GlobalKey<NavigatorState>(),
    TabItems.Profile: GlobalKey<NavigatorState>(),
    TabItems.MyChats: GlobalKey<NavigatorState>()
  };

  @override
  Widget build(BuildContext context) {
    final _usermodel = Provider.of<UserModel>(context);
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: Container(
          child: MyCustomButtomNavi(
        PageCreator: allPages(),
        Navigatorkeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: (seletedtab) {
          if (seletedtab == _currentTab) {
            navigatorKeys[seletedtab]!
                .currentState!
                .popUntil((route) => route.isFirst);
          }
          else{setState(() {
            _currentTab = seletedtab;
          });
          print("selectedtab" + seletedtab.index.toString());}

          
        },
      )),
    );
  }
}
