import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state/nav_state.dart';
import '../../shared/constant/style_constant.dart';
import '../../shared/widgets/nav_bar.dart';
import '../../shared/widgets/nav_model.dart';
import '../app/app_picker_screen.dart';
import '../profile/account_screen.dart';
import '../task/tasks_screen.dart';
import 'dashboard_screen.dart'; // <-- add this

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final searchNavKey = GlobalKey<NavigatorState>();
  final notificationNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();

  late final List<NavModel> items;

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(page: const DashboardScreen(), navKey: homeNavKey), // 0
      NavModel(page: const AppPickerScreen(), navKey: searchNavKey), // 1
      NavModel(page: const TasksScreen(), navKey: notificationNavKey), // 2
      NavModel(page: const AccountScreen(), navKey: profileNavKey), // 3
    ];
  }

  @override
  Widget build(BuildContext context) {
    // READ current tab from Riverpod
    final selectedTab = ref.watch(currentTabProvider);

    return PopScope(
      canPop: false, // disable auto-pop, so we handle it manually
      onPopInvokedWithResult: (didPop, result) {
        final nav = items[selectedTab].navKey.currentState;
        if (nav?.canPop() ?? false) {
          nav!.pop();
        } else {
          // If navigator cannot pop, allow system to handle (e.g. exit app)
        }
      },
      child: Scaffold(
        backgroundColor: AppConst.primaryColor,
        body: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppConst.circleSize),
            bottomRight: Radius.circular(AppConst.circleSize),
          ),
          child: Container(
            color: AppConst.primaryColor, // background color for all screens
            child: IndexedStack(
              index: selectedTab,
              children: items.map((page) {
                return Navigator(
                  key: page.navKey,
                  onGenerateInitialRoutes: (navigator, initialRoute) {
                    return [MaterialPageRoute(builder: (_) => page.page)];
                  },
                );
              }).toList(),
            ),
          ),
        ),
        bottomNavigationBar: NavBar(
          pageIndex: selectedTab,
          onTap: (index) {
            if (index == selectedTab) {
              items[index].navKey.currentState?.popUntil(
                (route) => route.isFirst,
              );
            } else {
              // SET current tab via Riverpod
              ref.read(currentTabProvider.notifier).state = index;
            }
          },
        ),
      ),
    );
  }
}
