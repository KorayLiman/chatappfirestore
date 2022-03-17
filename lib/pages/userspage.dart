import 'package:chat/models/usermodel.dart';
import 'package:chat/pages/konusmapage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../viewmodels/usermodel.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<UserP> tumkullanicilar = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _getirilecekElemanSayisi = 10;
  UserP? _ensongetirilenuser;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    getUser(_ensongetirilenuser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    _userModel.getAllUsers();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Users"),
        ),
        body: FutureBuilder<List<UserP>>(
          future: _userModel.getAllUsers(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var oankiuser = snapshot.data![index];
                return ListTile(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => KonusmaPage(
                                currentUser: _userModel.user!,
                                sohbetedilenuser: oankiuser)));
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        NetworkImage(snapshot.data![index].profileUrl!),
                  ),
                  title: Text(snapshot.data![index].userName!),
                  subtitle: Text(snapshot.data![index].email!),
                );
              },
            );
          },
        ));
  }

  getUser(UserP? ensongetirilenuser) async {
    QuerySnapshot querySnapshot;
    if (ensongetirilenuser == null) {
      querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(_getirilecekElemanSayisi)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([ensongetirilenuser.userName])
          .limit(_getirilecekElemanSayisi)
          .get();
    }

    for (var snap in querySnapshot.docs) {
      UserP user = UserP.fromMap(snap.data() as Map<String, dynamic>);
      tumkullanicilar.add(user);
    }
    ensongetirilenuser = tumkullanicilar.last;
  }
}
