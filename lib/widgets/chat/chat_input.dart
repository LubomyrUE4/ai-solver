import 'package:flutter/material.dart';

import '../../constants.dart';

class InputChatText extends StatelessWidget {
  const InputChatText(
      {super.key,
      required this.inputController,
      required this.inputHeight,
      required this.onPressed});

  final TextEditingController inputController;
  final double inputHeight;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kMessageContainerDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0, top: 0, bottom: 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width / 3.0,
                height: inputHeight,
                child: ListView(children: <Widget>[
                  TextFormField(
                    controller: inputController,
                    decoration: kMessageTextFieldDecoration,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  )
                ]),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
              valueListenable: inputController,
              builder: (context, value, child) {
                return MaterialButton(
                  shape: const CircleBorder(),
                  color: Colors.blue,
                  onPressed: value.text.isNotEmpty
                      ? () => onPressed(value.text)
                      : () {},
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
