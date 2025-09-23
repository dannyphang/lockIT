import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/screens/home/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/app_state.dart';
import '../../shared/constant/style_constant.dart';
import 'widgets/permission_tile.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool usageGranted = false;
  bool overlayGranted = false;
  bool accessibilityGranted = false;

  @override
  Widget build(BuildContext context) {
    final canContinue =
        usageGranted && overlayGranted; // accessibility optional

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to LockGate')),
      body: Padding(
        padding: const EdgeInsets.all(AppConst.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Let\'s set things up',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppConst.spacing),
            const Text(
              'We\'ll ask for a couple of permissions so LockGate can monitor app launches and show a blocking gate.',
            ),
            const SizedBox(height: AppConst.spacing),
            PermissionTile(
              title: 'Usage Access',
              subtitle: 'To detect which app is currently on screen',
              granted: usageGranted,
              onRequest: () async {
                // TODO: open Usage Access settings via intent
                setState(() => usageGranted = true);
              },
            ),
            const SizedBox(height: AppConst.spacing),
            PermissionTile(
              title: 'Draw over other apps',
              subtitle: 'To display the LockGate screen over blocked apps',
              granted: overlayGranted,
              onRequest: () async {
                // TODO: open overlay settings
                setState(() => overlayGranted = true);
              },
            ),
            const SizedBox(height: AppConst.spacing),
            PermissionTile(
              title: 'Accessibility (optional)',
              subtitle:
                  'For faster detection on some devices (with disclosure)',
              granted: accessibilityGranted,
              onRequest: () async {
                // TODO: open accessibility settings with disclosure
                setState(() => accessibilityGranted = true);
              },
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: canContinue
                  ? () {
                      ref.read(appPrefsProvider.notifier).finishOnboarding();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MainScreen()),
                      );
                    }
                  : null,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
