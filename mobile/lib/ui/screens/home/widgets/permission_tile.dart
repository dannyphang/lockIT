import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

class PermissionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool granted;
  final Future<void> Function() onRequest;

  const PermissionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.granted,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          granted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: granted ? AppTheme.light().primaryColor : null,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: FilledButton(
          onPressed: onRequest,
          child: Text(granted ? 'Granted' : 'Grant'),
        ),
      ),
    );
  }
}
