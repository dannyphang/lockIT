import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lock_it/services/api/user_api.dart';
import 'package:logger/logger.dart';

import '../../../environment/environment.dart';
import '../../../state/user_state.dart';
import '../../shared/constant/style_constant.dart';
import '../../shared/widgets/base_dropdown.dart';
import '../../shared/widgets/base_text_input.dart';

class AccountDetail extends ConsumerStatefulWidget {
  const AccountDetail({super.key});
  @override
  ConsumerState<AccountDetail> createState() => _AccountDetailState();
}

final userApiProvider = Provider<UserApi>((ref) {
  return UserApi(env['base']!); // make sure env['base'] exists
});

class _AccountDetailState extends ConsumerState<AccountDetail> {
  final controllers = AccountFormControllers();
  bool _prefilled = false; // prevent repeated overwrites

  @override
  void dispose() {
    controllers.dispose();
    super.dispose();
  }

  Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? xfile = await picker.pickImage(source: ImageSource.gallery);
    final size = await xfile?.length();
    Logger().d({
      'name': xfile?.name,
      'path': xfile?.path,
      'size': size,
      'mime': xfile?.mimeType,
    });
    return xfile;
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    final token = ref.watch(authTokenProvider);
    final userApi = ref.read(userApiProvider);

    XFile? avatarFile;

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
                        Stack(
                          children: [
                            // Avatar
                            CircleAvatar(
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
                            // Small circle (edit button)
                            Positioned(
                              bottom: 0, // bottom-right corner
                              right: 0,
                              child: InkWell(
                                onTap: () async {
                                  avatarFile = await pickImage();
                                  appUser?.avatarUrl = avatarFile?.path;
                                  // if (avatarFile != null) {
                                  //   setState(() {
                                  //     Logger().d(avatarFile);
                                  //     appUser?.avatarUrl = avatarFile?.path;
                                  //   });
                                  // }
                                },
                                child: CircleAvatar(
                                  radius: AppConst
                                      .circleSizeXXS, // size of small button
                                  backgroundColor: AppConst.primaryColor,
                                  child: SvgPicture.asset(
                                    "assets/icons/camera.svg",
                                    width: AppConst.circleSizeXS,
                                    height: AppConst.circleSizeXS,
                                    colorFilter: const ColorFilter.mode(
                                      AppConst.secondaryTextColor,
                                      BlendMode.srcIn,
                                    ), // icon color
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                    userApi
                        .uploadAvatar(avatarFile, token ?? '')
                        .then(
                          (url) => {
                            userApi.updateMe(
                              token ?? '',
                              displayName:
                                  controllers.displayName.text.isNotEmpty
                                  ? controllers.displayName.text
                                  : null,
                              email: controllers.email.text.isNotEmpty
                                  ? controllers.email.text
                                  : null,
                              avatarUrl: url,
                            ),
                          },
                        );
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
