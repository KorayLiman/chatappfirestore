import 'dart:io';

import 'package:chat/common_widgets/platformduyarlialertdiyalog.dart';
import 'package:chat/common_widgets/socialloginbuttons.dart';
import 'package:chat/viewmodels/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _controller;
  File? image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller;
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    _controller.text = _userModel.user!.userName!;
    print("Profil sayfasındaki user değerleri: " + _userModel.user.toString());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          actions: [
            TextButton(
                onPressed: () => _cikisIcinOnayIste(context),
                child: const Text(
                  "Exit",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton.icon(
                                      onPressed: () {
                                        _kameradanfotocek();
                                      },
                                      icon: Icon(Icons.camera),
                                      label: const Text("Kamerayı aç")),
                                  TextButton.icon(
                                      onPressed: () {
                                        galeridenfotosec();
                                      },
                                      icon: Icon(Icons.browse_gallery),
                                      label: const Text("Galeriden seç"))
                                ],
                              ),
                            );
                          });
                    },
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.transparent,
                      backgroundImage: image == null
                          ? NetworkImage(_userModel.user!.profileUrl ?? "")
                          : FileImage(image!) as ImageProvider,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _userModel.user!.email,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: "Email", border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                        labelText: "Kullanıcı adı",
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SocilLoginButton(
                      text: "Değişiklikleri kaydet",
                      color: Colors.purple,
                      buttonIcon: Icon(Icons.abc),
                      onPressed: () {
                        _userNameGuncelle(context);
                        _profilfotoguncelle(context);
                      }),
                )
              ],
            ),
          ),
        ));
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _usermodel = Provider.of<UserModel>(context, listen: false);
    bool result = await _usermodel.singOut();

    return result;
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDiyalog(
      baslik: "Emin misiniz?",
      icerik: "Çıkmak istediğinizden emin misiniz",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);
    if (sonuc) {
      _cikisYap(context);
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user!.userName != _controller.text) {
      var updateresult = await _userModel.updateUserName(
          _userModel.user!.userId, _controller.text);
      if (updateresult == true) {
        PlatformDuyarliAlertDiyalog(
          baslik: "Başarılı",
          icerik: "Kullanıcı adı değiştirildi",
          anaButonYazisi: "Tamam",
        ).goster(context);
      } else {
        PlatformDuyarliAlertDiyalog(
          baslik: "Hata",
          icerik: "Kullanıcı adı kullanılıyor",
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    } else {
      _controller.text = _userModel.user!.userName!;
      PlatformDuyarliAlertDiyalog(
        baslik: "Hata",
        icerik: "Kullanıcı adı kullanılıyor",
        anaButonYazisi: "Tamam",
      ).goster(context);
    }
  }

  void _kameradanfotocek() async {
    XFile? image1 = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image1 != null) {
      File img = File(image1.path);
      image = img;
    }
    setState(() {});
    Navigator.pop(context);
  }

  void galeridenfotosec() async {
    XFile? image1 = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image1 != null) {
      File img = File(image1.path);
      image = img;
    }
    setState(() {});
    Navigator.pop(context);
  }

  void _profilfotoguncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (image != null) {
      var url = await _userModel.uploadFile(
          _userModel.user!.userId, "profile photo", image);
    }
  }
}
