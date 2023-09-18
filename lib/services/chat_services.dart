import 'dart:convert';

import 'package:offers_awards/models/chat.dart';
import 'package:offers_awards/screens/widgets/custom_snackbar.dart';
import 'package:offers_awards/utils/api_list.dart';
import 'package:offers_awards/utils/network.dart';

class ChatServices {
  Future<List<Chat>> fetch() async {
    List<Chat> chatList = [];
    final response = await Network.httpGetRequest(APIList.getChat, {});
    if (response.statusCode == 200) {
      for (final Map<String, dynamic> chat
      in jsonDecode(response.body)['data']) {
        chatList.add(Chat.fromJson(chat));
      }
      return chatList;
    } else {
      throw Exception('Failed to connect remote data source');
    }
  }

  Future<bool> send({
    required String message,
  }) async {
    final response = await Network.httpPostRequest(APIList.sendMessage, {
      'message': message.toString(),
    });

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 422) {
      CustomSnackBar.showRowSnackBarError(jsonDecode(response.body)['data']);
      return false;
    }
    throw Exception('Failed to connect remote data source');
  }
}
