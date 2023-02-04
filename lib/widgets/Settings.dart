import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

import '../StoreData.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State createState() => _Settings();
}

class _Settings extends State<Settings> {
  bool a = false;
  late bool enableAI1 = false;

  void loadEnableAI1() async {
    var enableAI1String = await StoreData.instance.getString("enable_ai1");
    setState(() {
      enableAI1 = enableAI1String.toLowerCase() == 'true';
    });
  }

  @override
  Widget build(BuildContext context) {
    loadEnableAI1();
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'common',
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              leading: Icon(Icons.format_paint),
              title: 'Enable Sonic AI',
              switchValue: enableAI1,
              onToggle: (bool value) async {
                await StoreData.instance.saveString("enable_ai1", value.toString());
            },
            ),
          ],
        ),
      ],
    );
  }
}