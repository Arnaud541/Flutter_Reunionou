import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reunionou/class/user.dart';

import 'package:reunionou/class/event.dart';
import 'package:reunionou/providers/user_provider.dart';

class EventProvider extends ChangeNotifier {
  Future<Event> getEventById(BuildContext context, int id) async {
    late Event event;
    final Dio dio = Dio();

    String token = Provider.of<UserProvider>(context, listen: false)
        .currentUser!
        .accessToken;
    Response response = await dio.get('http://localhost:19185/event/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}));

    if (response.statusCode == 200) {
      event = Event(
          response.data["event"]["id"],
          response.data["event"]["title"],
          response.data["event"]["description"],
          response.data["event"]["longitude"],
          response.data["event"]["latitude"],
          response.data["event"]["street"],
          response.data["event"]["city"],
          response.data["event"]["zipcode"],
          response.data["event"]["date"]);
    }

    return event;
  }
}
