import 'package:chat/common_widgets/platformduyarlialertdiyalog.dart';
import 'package:chat/common_widgets/socialloginbuttons.dart';
import 'package:chat/exceptions.dart';
import 'package:chat/models/usermodel.dart';
import 'package:chat/pages/homepage.dart';
import 'package:chat/viewmodels/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EmailPwLoginPage extends StatefulWidget {
  const EmailPwLoginPage({Key? key}) : super(key: key);

  @override
  State<EmailPwLoginPage> createState() => _EmailPwLoginPageState();
}

enum FormType { register, login }

class _EmailPwLoginPageState extends State<EmailPwLoginPage> {
  String? _email, _password;
  final _formkey = GlobalKey<FormState>();
  late String _buttonText, _linkText;
  var _formType = FormType.login;
  @override
  Widget build(BuildContext context) {
    _buttonText = _formType == FormType.login ? "Giriş yap" : "Kayıt ol";
    _linkText = _formType == FormType.login
        ? "Hesabınız yok mu? Kayıt olun"
        : "Hesabınız var mı? Giriş yapın";

    final _usermodel = Provider.of<UserModel>(context);

//  if (_usermodel.viewstate == ViewState.idle) {
//       if (_usermodel.user != null) {
//         return HomePage();
//       }
//     } else {
//       return
//          Center(
//           child: CircularProgressIndicator(),
//         )
//       ;
//     }

    if (_usermodel.user != null) {
      Future.delayed(
        Duration(milliseconds: 50),
        () => Navigator.pop(context),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Giriş / Kayıt"),
        ),
        body: _usermodel.viewstate == ViewState.idle
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.length < 3) {
                                return "mail must be greater than 2";
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                errorText: _usermodel.emailerrormessage == null
                                    ? null
                                    : _usermodel.emailerrormessage,
                                prefixIcon: Icon(Icons.mail),
                                hintText: "Mail giriniz",
                                label: const Text("Email"),
                                border: OutlineInputBorder()),
                            onChanged: (value) {
                              _email = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.length < 3) {
                                return "pw must be greater than 2";
                              }
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                errorText:
                                    _usermodel.passworderrormessage == null
                                        ? null
                                        : _usermodel.passworderrormessage,
                                prefixIcon: Icon(Icons.mail),
                                hintText: "Şifre giriniz",
                                label: const Text("Şifre"),
                                border: OutlineInputBorder()),
                            onChanged: (value) {
                              _password = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SocilLoginButton(
                              text: _buttonText,
                              color: Colors.green,
                              buttonIcon: Icon(Icons.login),
                              onPressed: () => _FormSubmit()),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () => _switch(),
                              child: Text(_linkText))
                        ],
                      )),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  void _FormSubmit() async {
    if (_email != null && _password != null) {
      _formkey.currentState!.save();
      print(_email! + _password!);
      final _userModel = Provider.of<UserModel>(context, listen: false);
      if (_formType == FormType.login) {
        try {
          UserP? LoggedinUser =
              await _userModel.signInWithEmailandPassword(_email, _password);
          if (LoggedinUser != null) {
            print(LoggedinUser.userId);
          }
        } catch (error) {
          PlatformDuyarliAlertDiyalog(
                  baslik: "Kullanıcı bulunamadı",
                  icerik: "Belirtilen hesap bulunamadı",
                  anaButonYazisi: "Tamam")
              .goster(context);
        }
      } else {
        try {
          UserP? RegisteredUser = await _userModel
              .createUserWithEmailandPassword(_email, _password);
          if (RegisteredUser != null) {
            print(RegisteredUser.userId);
          }
        } catch (error) {
          //print(Errors.goster(error.code) + "Kullanıcı oluşturma hatası");
          PlatformDuyarliAlertDiyalog(
            anaButonYazisi: "Tamam",
            baslik: "Kullanıcı oluşturma hata",
            icerik: "Mail kullanılıyor",
          ).goster(context);
        }
      }
    }
  }

  void _switch() {
    setState(() {
      _formType =
          _formType == FormType.login ? FormType.register : FormType.login;
    });
  }
}
