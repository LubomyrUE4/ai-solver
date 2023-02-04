import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:solver/StoreData.dart';

class ChatStream extends StatelessWidget {
  const ChatStream({super.key});

  Stream<List<MessageBubble>> getUserEmail() async* {
    List<MessageBubble> messages = List.empty();
    yield await StoreData.instance.getString("messages").then((messagesString) {
      messages = MessageBubble.decode(messagesString);
      return messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getUserEmail(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessageBubble> messageWidgets = [];
          final List<MessageBubble> messages = snapshot.data ?? List.empty();
          for (var message in messages) {
            final msgText = message.msgText;
            final msgSender = message.msgSender;
            final user = message.user;
            final msgBubble = MessageBubble(
                msgText: msgText, msgSender: msgSender, user: user);
            messageWidgets.add(msgBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: messageWidgets.reversed.toList(),
            ),
          );
        } else {
          return const Center(
            child:
                CircularProgressIndicator(backgroundColor: Colors.deepPurple),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool user;

  const MessageBubble(
      {super.key,
      required this.msgText,
      required this.msgSender,
      required this.user});

  factory MessageBubble.fromJson(Map<String, dynamic> jsonData) {
    return MessageBubble(
      msgText: jsonData['msgText'],
      msgSender: jsonData['msgSender'],
      user: jsonData['user'],
    );
  }

  static Map<String, dynamic> toMap(MessageBubble messageBubble) => {
        'msgText': messageBubble.msgText,
        'msgSender': messageBubble.msgSender,
        'user': messageBubble.user,
      };

  static String encode(List<MessageBubble> messageBubbles) => json.encode(
        messageBubbles
            .map<Map<String, dynamic>>((music) => MessageBubble.toMap(music))
            .toList(),
      );

  static List<MessageBubble> decode(String messageBubbles) =>
      (json.decode(messageBubbles) as List<dynamic>)
          .map<MessageBubble>((item) => MessageBubble.fromJson(item))
          .toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment:
            user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              msgSender,
              style: const TextStyle(
                  fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: user ? Radius.circular(50) : Radius.circular(0),
              bottomRight: Radius.circular(50),
              topRight: user ? Radius.circular(0) : Radius.circular(50),
            ),
            color: user ? Colors.blue : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: !user
                  ? Text(
                      msgText,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                      ),
                    )
                  : Text(
                      msgText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
