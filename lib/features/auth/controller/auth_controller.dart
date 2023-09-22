// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/repository/auth_repository.dart';
import 'package:reddit/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) {
  //login할 때 state의 상태를 currentUser로 만들어준다.
  return null;
});

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  );
});

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getuserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getuserData(uid);
}); //stream이므로 계속 받는다는건가.

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;

    user.fold((l) => showSnackBar(context, l.message), (userModel) {
      _ref.read(userProvider.notifier).update((state) => userModel);
    });
  }

  Stream<UserModel> getuserData(String uid) {
    return _authRepository.getuserData(uid);
  }

  void signOut() async {
    _authRepository.signOut();
  }
}
