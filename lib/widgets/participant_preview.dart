import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/class/participant.dart';
import 'package:reunionou/providers/user_provider.dart';
import 'package:reunionou/widgets/popup_comment.dart';

class ParticipantPreview extends StatefulWidget {
  final Participant participant;
  const ParticipantPreview({super.key, required this.participant});

  @override
  ParticipantPreviewState createState() {
    return ParticipantPreviewState();
  }
}

class ParticipantPreviewState extends State<ParticipantPreview> {
  late Participant _participant;

  @override
  void initState() {
    super.initState();
    _participant = widget.participant;
  }

  void changeStatus(BuildContext context, String status) async {
    setState(() {
      _participant.status = status;
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const PopupComment();
        });

    final Dio dio = Dio();
    Response response = await dio.put('https://fruits.shrp.dev/auth/login',
        data: {'id_participant': _participant.id, 'status': status});

    if (response.statusCode == 200) {
      final snackBar = SnackBar(
        content: status == "accepted"
            ? const Text("Vous avez accepté l'évènement")
            : const Text("Vous avez refusé l'évènement"),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.orange,
      );

      //ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_participant.avatar),
          backgroundColor: Colors.transparent,
        ),
        title: Text("${_participant.firstname} ${_participant.lastname}"),
        subtitle: Text(_participant.status),
        isThreeLine: true,
        trailing: Provider.of<UserProvider>(context, listen: false)
                    .currentUser!
                    .email ==
                _participant.email
            ? Wrap(direction: Axis.vertical, children: [
                IconButton(
                    icon: const Icon(Icons.thumb_up),
                    color: Colors.green,
                    onPressed: () => changeStatus(context, "accepted")),
                IconButton(
                    icon: const Icon(Icons.thumb_down),
                    color: Colors.red,
                    onPressed: () => changeStatus(context, "declined")),
              ])
            : null,
        onTap: () {
          null;
        });
  }
}
