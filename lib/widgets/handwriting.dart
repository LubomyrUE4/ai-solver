import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:photo_view/photo_view.dart';

class HandwritingWidget extends StatefulWidget {
  const HandwritingWidget({super.key});

  @override
  State<HandwritingWidget> createState() => _HandwritingWidgetState();
}

class _HandwritingWidgetState extends State<HandwritingWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  String textt = "";
  bool viewPhoto = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: viewPhoto
            ? PhotoView(
                onTapUp: (context, details, controllerValue) {
                  setState(() {
                    viewPhoto = false;
                  });
                },
                imageProvider: MemoryImage(base64Decode(textt)))
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    textt != ""
                        ? Flexible(
                            child: Container(
                                height: 500.0,
                                width: 385.0, //800 × 1128 pixels
                                alignment: Alignment.center, // This is needed
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        viewPhoto = true;
                                      });
                                    }, // Image tapped
                                    child: Image.memory(base64Decode(textt)))))
                        : Spacer(),
                    Row(
                      children: [
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width -
                              MediaQuery.of(context).size.width / 3,
                          margin: const EdgeInsets.only(
                              left: 15, right: 15, top: 10),
                          child: ListView(
                            children: const <Widget>[
                              TextField(
                                minLines: 1,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.black54,
                                    )),
                                    border: InputBorder.none,
                                    isDense: true),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                textt = "";
                              });
                              makePostRequest(myController.text).then(
                                (String result) {
                                  setState(() {
                                    textt = result;
                                  });
                                },
                              );
                            },
                            child: Text("Submit"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
  }

  Future<String> makePostRequest(final String text) async {
    final uri = Uri.parse('http://10.0.2.2:9092/hw');
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = <String, dynamic>{};
    await Future.wait<void>([
      _getId().then((String result) {
        body = {'userId': result, 'inputText': text};
      } as FutureOr<void> Function(String? value))
    ]);
    print(body);
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    // var jsonDecode1 = jsonDecode(response.body);
    // print(jsonDecode1.toString());
    return response.body;
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      var androidId = androidDeviceInfo.id;
      return androidId; // unique ID on Android
    }
    return "null";
  }
}
