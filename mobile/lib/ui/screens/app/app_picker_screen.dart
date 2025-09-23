import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/app_state.dart';
import '../../shared/constant/style_constant.dart';

class AppPickerScreen extends ConsumerWidget {
  const AppPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(appsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose apps to block')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppConst.spacing),
        itemCount: apps.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final a = apps[i];
          return SwitchListTile(
            title: Text(a.name),
            subtitle: Text(a.package),
            value: a.blocked,
            onChanged: (v) =>
                ref.read(appsProvider.notifier).toggleBlock(a.package, v),
            secondary: const CircleAvatar(
              backgroundColor: AppConst.primaryColor,
              child: Icon(Icons.apps, color: AppConst.secondaryTextColor),
            ),
            trackColor: WidgetStateProperty.all(AppConst.primaryColor),
            inactiveTrackColor: AppConst.secondaryTextColor,
            trackOutlineColor: WidgetStateProperty.all(AppConst.primaryColor),
            activeThumbColor: AppConst.secondaryTextColor,
            inactiveThumbColor: AppConst.disableColor,
          );
        },
      ),
    );
  }
}
