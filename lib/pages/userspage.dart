import 'package:chat/models/usermodel.dart';
import 'package:chat/pages/konusmapage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/usermodel.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    _userModel.getAllUsers();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Users"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(
                    builder: (context) => TestPage(),
                  ));
                },
                icon: Icon(Icons.title))
          ],
        ),
        body: FutureBuilder<List<UserP>>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var allUsers = snapshot.data;
              if (allUsers!.length - 1 > 0) {
                return RefreshIndicator(
                  onRefresh: () {
                    return kullanicilarlistesiniguncelle();
                  },
                  child: ListView.builder(
                    itemCount: allUsers.length,
                    itemBuilder: (context, index) {
                      var currentUser = snapshot.data![index];
                      if (snapshot.data![index].userId !=
                          _userModel.user!.userId) {
                        return ListTile(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                              builder: (context) => KonusmaPage(
                                currentUser: _userModel.user!,
                                sohbetedilenuser: currentUser,
                              ),
                            ));
                          },
                          title: Text(snapshot.data![index].userName!),
                          subtitle: Text(currentUser.email!),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(currentUser.profileUrl!),
                            backgroundColor: Colors.transparent,
                          ),
                        );
                      } else {
                        return Center(child: Container());
                      }
                    },
                  ),
                );
              } else {
                return RefreshIndicator(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(height: MediaQuery.of(context).size.height-150,
                          child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.supervised_user_circle),
                            const Text("Henüz kullanıcı yok")
                          ],
                        ),
                      )),
                    ),
                    onRefresh: kullanicilarlistesiniguncelle);
              }
            } else {
              return CircularProgressIndicator();
            }
          },
          future: _userModel.getAllUsers(),
        ));
  }

  Future<void> kullanicilarlistesiniguncelle() async {
    setState(() {});
  }
}

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
