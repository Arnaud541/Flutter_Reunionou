import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/providers/user_provider.dart';

class PopupComment extends StatefulWidget {
  final int eventId;
  const PopupComment({super.key, required this.eventId});

  @override
  PopupCommentState createState() {
    return PopupCommentState();
  }
}

class PopupCommentState extends State<PopupComment> {
  late int _eventId;
  final _formKey = GlobalKey<FormState>();

  final myControllerComment = TextEditingController();

  @override
  void dispose() {
    myControllerComment.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _eventId = widget.eventId;
  }

  void submitForm(String comment, BuildContext context) async {
    final Dio dio = Dio();
    String token = Provider.of<UserProvider>(context, listen: false)
        .currentUser!
        .accessToken;
    Response response = await dio.post(
        'http://localhost:19185/event/$_eventId/comment',
        data: {'content': comment},
        options: Options(headers: {'Authorization': 'Bearer $token'}));

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un commentaire'),
      content: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Message",
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          hintText: "Message",
                          hintStyle: TextStyle(color: Colors.grey[500])),
                      controller: myControllerComment,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Message non valide';
                        }
                        return null;
                      },
                    )),
              ],
            ))
      ])),
      actions: <Widget>[
        TextButton(
          child: const Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Enregistrer'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              submitForm(myControllerComment.text, context);
            }
            // save the form data
          },
        ),
      ],
    );
  }
}
