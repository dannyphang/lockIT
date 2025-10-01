import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';

import '../../../state/user_state.dart';
import '../../shared/constant/style_constant.dart';
import '../../shared/widgets/base_dropdown.dart';
import '../../shared/widgets/base_text_input.dart';

class AccountDetail extends ConsumerStatefulWidget {
  const AccountDetail({super.key});
  @override
  ConsumerState<AccountDetail> createState() => _AccountDetailState();
}

class _AccountDetailState extends ConsumerState<AccountDetail> {
  final controllers = AccountFormControllers();
  bool _prefilled = false; // prevent repeated overwrites

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Account Details')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (appUser) {
          if (!_prefilled && appUser != null) {
            Logger().d(appUser);

            controllers.username.text = appUser.username;
            controllers.displayName.text = appUser.displayName ?? '';
            controllers.email.text = appUser.email;
            controllers.preferredLanguage ??= 'en';

            _prefilled = true;
          }

          return Container(
            padding: const EdgeInsets.all(AppConst.spacing),
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: AppConst.spacingS,
                      children: [
                        InkWell(
                          onTap: () {
                            Logger().d("Avatar tapped");
                          },
                          child: CircleAvatar(
                            radius: AppConst.circleSizeL,
                            child: appUser?.avatarUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      appUser!.avatarUrl!,
                                      width: AppConst.circleSizeL * 2,
                                      height: AppConst.circleSizeL * 2,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/icons/user.svg',
                                    width: AppConst.circleSizeL,
                                    height: AppConst.circleSizeL,
                                  ),
                          ),
                        ),
                        BaseTextInput(
                          label: 'Username',
                          controller: controllers.username,
                          disable: true,
                        ),
                        BaseTextInput(
                          label: 'Email',
                          controller: controllers.email,
                          mode: 'email',
                        ),
                        BaseTextInput(
                          label: 'Display Name',
                          controller: controllers.displayName,
                        ),
                        BaseDropdown(
                          label: 'Preferred Language',
                          value: controllers.preferredLanguage,
                          items: {"en": "English", "zh": "Chinese"},
                          onChanged: (value) {
                            setState(() {
                              controllers.preferredLanguage = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    // TODO: submit changes
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50), // full width
                    backgroundColor: AppConst.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConst.radiusS),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(color: AppConst.secondaryTextColor),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AccountFormControllers {
  final username = TextEditingController();
  final email = TextEditingController();
  final displayName = TextEditingController();
  final password = TextEditingController();
  String? preferredLanguage = "en";

  void dispose() {
    username.dispose();
    email.dispose();
    displayName.dispose();
    password.dispose();
  }

  Map<String, String?> value() => {
    "username": username.text,
    "email": email.text,
    "displayName": displayName.text,
    "preferredLanguage": preferredLanguage,
  };
}
