import 'package:flutter/material.dart';

import '../../shared/constant/style_constant.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rules & schedules')),
      body: ListView(
        padding: const EdgeInsets.all(AppConst.spacing),
        children: [
          Card(
            child: ListTile(
              title: const Text('Daily schedule'),
              subtitle: const Text('Block social apps from 8am–6pm'),
              trailing: OutlinedButton(
                onPressed: () {},
                child: const Text('Edit'),
              ),
            ),
          ),
          const SizedBox(height: AppConst.spacing),
          Card(
            child: ListTile(
              title: const Text('Emergency allow'),
              subtitle: const Text(
                'Define apps that are always allowed (e.g., Calls, Maps)',
              ),
              trailing: OutlinedButton(
                onPressed: () {},
                child: const Text('Manage'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
