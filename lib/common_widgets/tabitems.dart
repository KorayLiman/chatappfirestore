import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItems { Users, MyChats, Profile }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData({required this.title, required this.icon});

  static Map<TabItems, TabItemData> AllTabs = {
    TabItems.Users:
        TabItemData(title: "Users", icon: Icons.supervised_user_circle),
    TabItems.MyChats: TabItemData(title: "My Chats", icon: Icons.chat),
    TabItems.Profile: TabItemData(title: "Profile", icon: Icons.person)
  };
}
