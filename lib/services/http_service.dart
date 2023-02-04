import 'dart:convert';

import 'package:http/http.dart';

import '../enum_chat_types.dart';

class HttpService {

  HttpService._privateConstructor();

  static final HttpService instance = HttpService._privateConstructor();
  
  Future<String> sendRequestByChatType(final ChatType selectedChatType, final String inputText) {
    return askQuestion(inputText);
  }

  Future<String> askQuestion(final String text) async {
    final uri = Uri.parse('http://10.0.2.2:9092/ai');
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {'question': text};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    return response.body;
  }
}