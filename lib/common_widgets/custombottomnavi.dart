import 'package:chat/common_widgets/tabitems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomButtomNavi extends StatelessWidget {
  const MyCustomButtomNavi(
      {Key? key, required this.currentTab, required this.onSelectedTab,
      required this.PageCreator,
      required this.Navigatorkeys})
      : super(key: key);
  final TabItems currentTab;
  final ValueChanged<TabItems> onSelectedTab;
  final Map<TabItems, Widget> PageCreator;
  final Map<TabItems, GlobalKey<NavigatorState>> Navigatorkeys;


  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [_NavItem(TabItems.Users),
        _NavItem(TabItems.MyChats), _NavItem(TabItems.Profile)],
        onTap: (index) => onSelectedTab(TabItems.values[index]),
      ),
      tabBuilder: (context, index) {
        final gosterilecektab = TabItems.values[index];
        return CupertinoTabView(
          navigatorKey: Navigatorkeys[gosterilecektab],
            builder: (context) => PageCreator[gosterilecektab]!);
      },
    );
  }

  BottomNavigationBarItem _NavItem(TabItems tabItem) {
    final olusturulacakcurrenttab = TabItemData.AllTabs[tabItem];
    return BottomNavigationBarItem(
        icon: Icon(olusturulacakcurrenttab!.icon),
        label: olusturulacakcurrenttab.title);
  }
}
