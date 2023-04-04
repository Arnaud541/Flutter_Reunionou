import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/class/user.dart';
import 'package:reunionou/providers/user_provider.dart';
import 'package:reunionou/screens/home_screen.dart';

import '../widgets/navbar.dart';

class SigninInvitationScreen extends StatefulWidget {
  const SigninInvitationScreen({super.key});

  @override
  SigninInvitationScreenState createState() {
    return SigninInvitationScreenState();
  }
}

class SigninInvitationScreenState extends State<SigninInvitationScreen> {
  final _formKey = GlobalKey<FormState>();

  final myControllerLastname = TextEditingController();
  final myControllerFirstname = TextEditingController();
  final myControllerEmail = TextEditingController();

  @override
  void dispose() {
    myControllerLastname.dispose();
    myControllerFirstname.dispose();
    myControllerEmail.dispose();
    super.dispose();
  }

  void submitForm(String lastname, String firstname, String email) async {
    final Dio dio = Dio();
    Response response = await dio.post('https://fruits.shrp.dev/auth/login',
        data: {
          'lastname': myControllerLastname,
          'firstname': myControllerFirstname,
          'email': myControllerEmail.text
        });

    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));

    //ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Voici la page d'évènement")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100), child: Navbar(),
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Inscription à l\'évènement',
                style: TextStyle(fontSize: 30, color: Colors.grey[700]),
              ),
              const SizedBox(height: 25),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white)),
                                labelText: "Nom",
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.grey.shade400),),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                hintText: "Nom",
                                hintStyle: TextStyle(color: Colors.grey[500])
                            ),
                            controller: myControllerLastname,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Le nom doit être complété';
                              } else if (!RegExp(r"^[a-zA-Z\'À-ÖØ-öø-ÿ-]+$")
                                  .hasMatch(
                                  value)) {
                                return 'Le nom ne peut contenir que des lettres, - ou espace';
                              }
                              return null;
                            },
                          )
                      ),
                      const SizedBox(height: 10),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white)),
                                labelText: "Prénom",
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.grey.shade400),),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                hintText: "Prénom",
                                hintStyle: TextStyle(color: Colors.grey[500])
                            ),
                            controller: myControllerFirstname,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Le prénom doit être complété';
                              } else if (!RegExp(r"^[a-zA-Z\'À-ÖØ-öø-ÿ-]+$")
                                  .hasMatch(
                                  value)) {
                                return 'Le prénom ne peut contenir que des lettres, - ou espace';
                              }
                              return null;
                            },
                          )
                      ),
                      const SizedBox(height: 10),
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
                                  BorderSide(color: Colors.grey.shade400),),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey[500])
                            ),
                            controller: myControllerEmail,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'L\'adresse email doit être complété';
                              } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(
                                  value)) {
                                return 'L\'adresse ne peut contenir de symboles autres que @, _, - ou .';
                              }
                              return null;
                            },
                          )),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submitForm(
                              myControllerLastname.text,
                              myControllerFirstname.text,
                              myControllerEmail.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(300, 25),
                            backgroundColor: const Color(0xFFA084DC)),
                        child: const Text(
                          'Valider l\'inscription',
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


