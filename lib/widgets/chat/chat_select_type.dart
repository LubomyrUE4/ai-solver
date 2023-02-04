import 'package:flutter/material.dart';
import 'package:solver/enum_chat_types.dart';

import 'chat.dart';

class AIChat extends StatefulWidget {
  const AIChat({super.key});

  @override
  State<AIChat> createState() => _AIChat();
}

class _AIChat extends State<AIChat> {
  late int selectedIndex = 0;
  late Map menu = {
    0: SelectMode(
      onPressed: setChatType
    ),
    1: Chatter(
      goBack: () => setChatType(0),
      selectedChatType: ChatType.chat_ai_messages,
    ),
    2: Chatter(
      goBack: () => setChatType(0),
      selectedChatType: ChatType.conclusion_writer,
    ),
    3: Chatter(
      goBack: () => setChatType(0),
      selectedChatType: ChatType.text_shortener,
    ),
    4: Chatter(
      goBack: () => setChatType(0),
      selectedChatType: ChatType.rephraser,
    ),
  };

  void setChatType(final int newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: menu[selectedIndex]);
  }
}

class SelectMode extends StatelessWidget {
  const SelectMode({
    super.key,
    required this.onPressed,
  });

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: const EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height,
      child: ListView(children: [
        SelectModeButton(
          icon: Icons.chat_bubble,
          text: 'Chatter (ask anything)',
          onPressed: () => onPressed(1),
        ),
        SelectModeButton(
          icon: Icons.translate,
          text: 'Conclustion maker',
          onPressed: () => onPressed(2),
        ),
        SelectModeButton(
          icon: Icons.build,
          text: 'Text shortener',
          onPressed: () => onPressed(3),
        ),
        SelectModeButton(
          icon: Icons.water,
          text: 'Rephraser',
          onPressed: () => onPressed(4),
        ),
      ]),
    ));
  }
}

class SelectModeButton extends StatelessWidget {
  const SelectModeButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // <-- Radius
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  size: 50,
                  icon,
                  color: Colors.white,
                ),
                const SizedBox(height: 15),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            )),
      ),
    );
  }
}
