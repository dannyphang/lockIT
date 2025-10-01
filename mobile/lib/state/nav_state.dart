import 'package:flutter_riverpod/flutter_riverpod.dart';

// 0=Dashboard, 1=Blocklist(AppPicker), 2=Tasks, 3=Account
final currentTabProvider = StateProvider<int>((ref) => 0);
