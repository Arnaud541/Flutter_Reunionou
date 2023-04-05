import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reunionou/screens/profile_screen.dart';

import 'package:reunionou/widgets/navbar.dart';

class CreateInvitationScreen extends StatefulWidget {
  const CreateInvitationScreen({super.key});

  @override
  CreateInvitationScreenState createState() {
    return CreateInvitationScreenState();
  }
}

class CreateInvitationScreenState extends State<CreateInvitationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _participants = [];

  final myControllerParticipantEmail = TextEditingController();

  @override
  void dispose() {
    myControllerParticipantEmail.dispose();

    super.dispose();
  }

  void submitForm(List<String> participants) async {
    final Dio dio = Dio();
    Response response = await dio.post('https://fruits.shrp.dev/auth/login',
        data: {'participants': _participants});

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()));

      //ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Votre évènement a été crée !")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100), child: Navbar()),
      backgroundColor: const Color(0xFFF2F2F2),
      body: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Invitation',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              Text(
                'Inviter des gens inscrit sur la plateforme',
                style: TextStyle(fontSize: 17, color: Colors.grey[400]),
              ),
              const SizedBox(height: 25),
              Form(
                  child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelText: "Email du participant",
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            hintText: "Email du participant",
                            hintStyle: TextStyle(color: Colors.grey[500])),
                        // inputFormatters: <TextInputFormatter>[
                        //   FilteringTextInputFormatter.allow(RegExp('')),
                        // ],
                        controller: myControllerParticipantEmail,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email du participant non valide';
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _participants.add(myControllerParticipantEmail.text);
                        myControllerParticipantEmail.text = '';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(215, 35),
                        backgroundColor: const Color(0xFFA084DC)),
                    child: const Text(
                      'Ajouter un participant',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // submitForm(participants)
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(215, 35),
                        backgroundColor: const Color(0xFFA084DC)),
                    child: const Text(
                      'Envoyer les invitations',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 50),
              Text(
                'Inviter des gens hors de la plateforme',
                style: TextStyle(fontSize: 17, color: Colors.grey[400]),
              ),
              const SizedBox(height: 15),
              Text(
                'Url à partager : ',
                style: TextStyle(fontSize: 17, color: Colors.grey[400]),
              )
            ],
          )),
    );
  }
}
