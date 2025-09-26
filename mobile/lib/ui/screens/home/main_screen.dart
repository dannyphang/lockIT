import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/ui/screens/profile/account_screen.dart';
import 'package:flutter_application_1/ui/screens/app/app_picker_screen.dart';
import 'package:flutter_application_1/ui/screens/home/dashboard_screen.dart';
import 'package:flutter_application_1/ui/screens/task/tasks_screen.dart';
import 'package:flutter_application_1/ui/shared/widgets/nav_bar.dart';
import 'package:flutter_application_1/ui/shared/widgets/nav_model.dart';

import '../../../state/nav_state.dart'; // <-- add this

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
        body: IndexedStack(
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

        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // // If you want display-only, you can drop the FAB wrapper and just use a SizedBox.
        // floatingActionButton: Container(
        //   margin: const EdgeInsets.only(top: 10),
        //   height: 64,
        //   width: 64,
        //   child: FloatingActionButton(
        //     backgroundColor: Colors.white,
        //     elevation: 0,
        //     onPressed: () => debugPrint("Points badge pressed"),
        //     shape: RoundedRectangleBorder(
        //       side: const BorderSide(width: 3, color: AppConst.primaryColor),
        //       borderRadius: BorderRadius.circular(AppConst.rounded),
        //     ),
        //     child: const Center(child: PointsCircle()),
        //   ),
        // ),
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
