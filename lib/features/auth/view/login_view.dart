import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/theme/pallete.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  void signWithGoogle(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  void signOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: Pallete.blackColor,
      appBar: AppBar(
        backgroundColor: Pallete.blackColor,
        title: CircleAvatar(
          backgroundImage: AssetImage(Constants.logoPath),
        ),
        actions: [
          TextButton(
            onPressed: () {
              signOut(ref);
            },
            child: Text(
              'Skip',
              style: TextStyle(color: Pallete.blueColor, fontSize: 17),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Loader()
          : Column(
              children: [
                SizedBox(height: 150),
                Image.asset(Constants.loginEmotePath),
                SizedBox(height: 80),
                ElevatedButton.icon(
                  style: ButtonStyle(),
                  onPressed: () {
                    signWithGoogle(ref, context);
                  },
                  icon: CircleAvatar(
                    backgroundImage: AssetImage(Constants.googlePath),
                  ),
                  label: Text('Sign with Google'),
                ),
              ],
            ),
    );
  }
}
