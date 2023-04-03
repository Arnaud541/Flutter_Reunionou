import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PopupComment extends StatefulWidget {
  const PopupComment({super.key});

  @override
  PopupCommentState createState() {
    return PopupCommentState();
  }
}

class PopupCommentState extends State<PopupComment> {
  final _formKey = GlobalKey<FormState>();

  final myControllerComment = TextEditingController();

  @override
  void dispose() {
    myControllerComment.dispose();
    super.dispose();
  }

  void submitForm(String comment) async {
    final Dio dio = Dio();
    Response response = await dio
        .post('https://fruits.shrp.dev/auth/login', data: {'content': comment});

    if (response.statusCode == 200) {}
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un commentaire'),
      content: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Form(
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
                          borderSide: BorderSide(color: Colors.grey.shade400)),
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
              submitForm(myControllerComment.text);
              Navigator.of(context).pop();
            }
            // save the form data
          },
        ),
      ],
    );
  }
}
