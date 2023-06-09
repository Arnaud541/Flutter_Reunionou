import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/user_provider.dart';
import 'package:reunionou/screens/profile_screen.dart';

import 'package:reunionou/widgets/navbar.dart';

class CreateInvitationScreen extends StatefulWidget {
  final int id;
  const CreateInvitationScreen({super.key, required this.id});

  @override
  CreateInvitationScreenState createState() {
    return CreateInvitationScreenState();
  }
}

class CreateInvitationScreenState extends State<CreateInvitationScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _id;
  final List<String> _participants = [];
  final myControllerParticipantEmail = TextEditingController();
  @override
  void dispose() {
    myControllerParticipantEmail.dispose();
    super.dispose();
  }

  void submitForm(List<String> participants) async {
    final Dio dio = Dio();
    String token = Provider.of<UserProvider>(context, listen: false)
        .currentUser!
        .accessToken;
    Response response = await dio.post(
        'http://localhost:19185/event/$_id/invite',
        data: {'participants': _participants},
        options: Options(headers: {'Authorization': 'Bearer $token'}));

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
  void initState() {
    super.initState();
    _id = widget.id;
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
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                labelText: "Email du participant",
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                hintText: "Email du participant",
                                hintStyle: TextStyle(color: Colors.grey[500])),
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
                            _participants
                                .add(myControllerParticipantEmail.text);
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
                            submitForm(_participants);
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
