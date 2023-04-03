import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/class/user.dart';
import 'package:reunionou/providers/user_provider.dart';
import 'package:reunionou/screens/home_screen.dart';

import '../widgets/navbar.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  SigninScreenState createState() {
    return SigninScreenState();
  }
}

class SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();

  final myControllerEmail = TextEditingController();
  final myControllerPassword = TextEditingController();

  @override
  void dispose() {
    myControllerEmail.dispose();
    myControllerPassword.dispose();
    super.dispose();
  }

  void submitForm(String email, String password) async {
    final Dio dio = Dio();
    Response response = await dio.post('https://fruits.shrp.dev/auth/login',
        data: {
          'email': myControllerEmail.text,
          'password': myControllerPassword.text
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> payload =
      Jwt.parseJwt(response.data["data"]["access_token"]);

      final User user = User(
          payload["id"],
          myControllerEmail.text,
          response.data["data"]["avatar"],
          response.data['data']["access_token"],
          response.data['data']["refresh_token"]);

      // ignore: use_build_context_synchronously
      Provider
          .of<UserProvider>(context, listen: false)
          .currentUser = user;

      // ignore: use_build_context_synchronously
      Provider
          .of<UserProvider>(context, listen: false)
          .isConnected = true;

      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));

      //ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vous êtes connecté !")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100), child: Navbar()),
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Connexion',
                style: TextStyle(fontSize: 30, color: Colors.grey[700]),
              ),
              const SizedBox(height: 25),
              Form(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white)),
                                labelText: "Email",
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey[500])),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp('')),
                            ],
                            controller: myControllerEmail,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'L\'adresse email doit être complété';
                              } else
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'L\'adresse ne peut pas contenir de symboles autres que @, _, - ou .';
                              }
                              return null;
                            },
                          )),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: "Mot de passe",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey
                                      .shade400)),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              hintText: "Mot de passe",
                              hintStyle: TextStyle(color: Colors.grey[500])),
                          controller: myControllerPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le mot de passe doit être complété';
                            } else if (value.contains("<") || value.contains(
                                ">") || value.contains("\"") ||
                                value.contains(";")) {
                              return 'Le mot de passe ne peut pas contenir de <>, de "" ou de ;';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submitForm(
                              myControllerEmail.text,
                              myControllerPassword.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(300, 25),
                            backgroundColor: const Color(0xFFA084DC)),
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ))
            ],
          )),
    );
  }
}
