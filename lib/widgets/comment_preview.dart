import 'package:flutter/material.dart';
import 'package:reunionou/class/comment.dart';

class CommentPreview extends StatelessWidget {
  final Comment comment;
  const CommentPreview({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          "${comment.participantFirstname} ${comment.participantLastname}"),
      subtitle: Text(comment.content),
    );
  }
}
