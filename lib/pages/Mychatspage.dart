import 'package:chat/models/usermodel.dart';
import 'package:chat/pages/konusmapage.dart';
import 'package:chat/viewmodels/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/konusma.dart';

class MyChats extends StatefulWidget {
  const MyChats({Key? key}) : super(key: key);

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  @override
  Widget build(BuildContext context) {
    final _usermodel = Provider.of<UserModel>(context);
    _konusmalarimiGetir();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konuşmalarım"),
      ),
      body: FutureBuilder<List<Konusma>>(
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKonusmalar = snapshot.data!;
            if(tumKonusmalar.length >0){
return RefreshIndicator(
              onRefresh: () {
                return _konusmalarimListesiniYenile();
              },
              child: ListView.builder(
                  itemCount: tumKonusmalar.length,
                  itemBuilder: (context, index) {
                    var oankikonusma = tumKonusmalar[index];
                    return ListTile(onTap: (){
                      Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                              builder: (context) =>  KonusmaPage(currentUser: _usermodel.user!, sohbetedilenuser: UserP.idveResim(userId: oankikonusma.kimle_konusuyor,  profileUrl: oankikonusma.konusuluanUserProfileUrl)),
                            ));
                    },
                      title: Text(oankikonusma.son_yollanan_mesaj!),
                      subtitle: Text(oankikonusma.konusulanUserName!),
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                            oankikonusma.konusuluanUserProfileUrl!),
                      ),
                    );
                  }),
            );
            }else{
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
                    onRefresh: _konusmalarimListesiniYenile);
            }
            
          }
        },
        future: _usermodel.getAllConversations(_usermodel.user!.userId),
      ),
    );
  }

  void _konusmalarimiGetir() async {
    final _usermodel = Provider.of<UserModel>(context);
    var konusmalarim = await FirebaseFirestore.instance
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: _usermodel.user!.userId)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();

    for (var konusma in konusmalarim.docs) {
      print("konusma:" + konusma.data().toString());
    }
  }

  Future<void> _konusmalarimListesiniYenile() async{
setState(() {
  
});
  }
}
