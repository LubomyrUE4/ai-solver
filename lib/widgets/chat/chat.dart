import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:solver/services/http_service.dart';

import '../../services/store_data_service.dart';
import 'chat_stream.dart';
import 'chat_input.dart';

class Chatter extends StatefulWidget {
  const Chatter({super.key, required this.goBack});

  final VoidCallback goBack;

  @override
  State<Chatter> createState() => _ChatterState();
}

class _ChatterState extends State<Chatter> {
  late final VoidCallback _goBack = widget.goBack;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  String textt = "";
  double _inputHeight = 50;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_checkInputHeight);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _checkInputHeight() async {
    int count = _inputController.text.split('\n').length;

    if (count == 0 && _inputHeight == 50.0) {
      return;
    }
    if (count <= 5) {
      var newHeight = count == 0 ? 50.0 : 28.0 + (count * 12.0);
      setState(() {
        _inputHeight = newHeight;
      });
    }
  }

  void onPressed(String valueText) {
    setState(() {
      textt = "";
    });
    StoreData.instance.getString("messages").then((messagesString) {
      var messages = MessageBubble.decode(messagesString);
      messages
          .add(MessageBubble(msgText: valueText, msgSender: "me", user: true));

      StoreData.instance.saveString("messages", MessageBubble.encode(messages));
      HttpService.instance.askQuestion(valueText).then(
        (String result) {
          setState(() {
            textt = result;
          });
          messages.add(
              MessageBubble(msgText: result, msgSender: "bot", user: false));
          StoreData.instance
              .saveString("messages", MessageBubble.encode(messages));
        },
      );
    });
    _inputController.clear();
  }

  _ChatterState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Bar"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack
        ),
      ),
      body: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.only(
                top: 20, left: 20.0, right: 20.0, bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ChatStream(),
                      InputChatText(
                          inputController: _inputController,
                          inputHeight: _inputHeight,
                          onPressed: onPressed)
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
