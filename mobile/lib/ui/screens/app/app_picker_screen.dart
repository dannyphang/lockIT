import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/state/app_state.dart';
import 'package:flutter_application_1/ui/shared/constant/style_constant.dart';

class AppPickerScreen extends ConsumerStatefulWidget {
  const AppPickerScreen({super.key});

  @override
  ConsumerState<AppPickerScreen> createState() => _AppPickerScreenState();
}

class _AppPickerScreenState extends ConsumerState<AppPickerScreen> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(appsProvider.notifier)
          .loadFromDevice(
            includeSystemApps: false, // set true if you want to see system apps
            includeIcons: false, // keep fast; wire icons later if needed
          );
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final apps = ref.watch(appsProvider);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Choose apps to block')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Choose apps to block')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppConst.spacing),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Failed to load apps:\n$_error',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConst.spacing),
                FilledButton(onPressed: _load, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Choose apps to block')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
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

              // Placeholder avatar; swap to real icons if you enable includeIcons
              secondary: CircleAvatar(
                backgroundColor: AppConst.primaryColor,
                child: Image.asset(a.icon),
              ),

              // Use MaterialStateProperty for these colors
              // trackColor: WidgetStatePropertyAll(AppConst.primaryColor),
              trackOutlineColor: WidgetStatePropertyAll(AppConst.primaryColor),
              inactiveTrackColor: AppConst.secondaryTextColor,
              activeThumbColor: AppConst.primaryColor,
              inactiveThumbColor: AppConst.disableColor,
            );
          },
        ),
      ),
    );
  }
}
