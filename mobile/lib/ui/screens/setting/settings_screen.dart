import 'package:flutter/material.dart';

import '../../shared/constant/style_constant.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppConst.spacing),
        children: [
          const Text('Permissions'),
          const SizedBox(height: AppConst.spacing),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.lock_clock),
                  title: Text('Usage access'),
                  subtitle: Text('Manage in system settings'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.layers),
                  title: Text('Draw over other apps'),
                  subtitle: Text('Manage in system settings'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.accessibility_new),
                  title: Text('Accessibility service (optional)'),
                  subtitle: Text('For faster detection on some devices'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConst.spacing),
          const Text('About'),
          const SizedBox(height: AppConst.spacing),
          const ListTile(
            title: Text('LockGate v0.1.0'),
            subtitle: Text('MVP UI — not blocking yet'),
          ),
        ],
      ),
    );
  }
}
