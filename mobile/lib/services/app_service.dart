import 'package:installed_apps/installed_apps.dart';

class AppService {
  Future<void> getInstalledApplications() async {
    final apps = await InstalledApps.getInstalledApps(true, false);
    apps.sort(
      (a, b) => (a.name).toLowerCase().compareTo((b.name).toLowerCase()),
    );
  }
}
